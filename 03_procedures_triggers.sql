-- Evita que la suma de los porcentajes sea mayor que 100%
CREATE OR REPLACE FUNCTION fn_validar_peso_evaluaciones()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_suma_pesos NUMERIC(6,2);
    BEGIN
        SELECT COALESCE(SUM(peso_porcentual), 0) -- Si no hay evaluaciones previas devuelve 0 en lugar de NULL
        INTO v_suma_pesos
        FROM evaluaciones
        WHERE id_asignacion_docente = NEW.id_asignacion_docente
        AND trimestre = NEW.trimestre
        -- Selecciona todas las evaluaciones excepto la que se está insertando o actualizando para evitar contar su peso dos veces
        -- si NEW.id_evaluacion es NULL (osea que es una inserción), se usa -1 para que no coincida con ningún id_evaluacion que exista
        AND id_evaluacion != COALESCE(NEW.id_evaluacion, -1);

        IF (v_suma_pesos + NEW.peso_porcentual) > 100.00 THEN
            RAISE EXCEPTION 'Exceso de peso acumulado: La suma de pesos para la asignatura en el trimestre % sería %. El peso máximo permitido es 100%%.',
                NEW.trimestre, (v_suma_pesos + NEW.peso_porcentual);
        END IF;
        
        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_validar_peso_evaluaciones ON evaluaciones;
CREATE TRIGGER trg_validar_peso_evaluaciones
BEFORE INSERT OR UPDATE ON evaluaciones
FOR EACH ROW 
EXECUTE FUNCTION fn_validar_peso_evaluaciones();


-- Calcula de forma automatizada los promedios ponderados por trimestre y el promedio final
-- y genera la alerta si cae por debajo de 6.00
CREATE OR REPLACE FUNCTION fn_actualizar_promedio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_id_inscripcion INT;
        v_trimestre INT;
        v_promedio NUMERIC(4,2);
        v_alerta_existe INT;
    BEGIN
        -- TG_OP retorna la operación que disparó el trigger ('INSERT', 'UPDATE' o 'DELETE')
        -- Se asigna el id_inscripcion y trimestre según corresponda la operación
        -- se selecciona el trimestre de la evaluación para saber cuál promedio actualizar (T1, T2 o T3)
        IF TG_OP = 'DELETE' THEN
            v_id_inscripcion := OLD.id_inscripcion;
            SELECT trimestre INTO v_trimestre FROM evaluaciones WHERE id_evaluacion = OLD.id_evaluacion;
        ELSE
            v_id_inscripcion := NEW.id_inscripcion;
            SELECT trimestre INTO v_trimestre FROM evaluaciones WHERE id_evaluacion = NEW.id_evaluacion;
        END IF;

        -- Calcula el promedio
        SELECT ROUND(
            -- Calcula el promedio ponderado sumando cada nota multiplicada por su peso porcentual y dividiendo entre la suma de los pesos
            SUM(n.nota * ev.peso_porcentual) / NULLIF(SUM(ev.peso_porcentual), 0),
            2
        ) INTO v_promedio
        FROM notas n
        JOIN evaluaciones ev ON ev.id_evaluacion = n.id_evaluacion
        WHERE n.id_inscripcion = v_id_inscripcion
        AND ev.trimestre = v_trimestre;

        -- Actualiza el promedio del trimestre correspondiente en la tabla inscripciones_asignaturas
        IF v_trimestre = 1 THEN
            UPDATE inscripciones_asignaturas SET promedio_t1 = v_promedio WHERE id_inscripcion = v_id_inscripcion;
        ELSIF v_trimestre = 2 THEN
            UPDATE inscripciones_asignaturas SET promedio_t2 = v_promedio WHERE id_inscripcion = v_id_inscripcion;
        ELSIF v_trimestre = 3 THEN
            UPDATE inscripciones_asignaturas SET promedio_t3 = v_promedio WHERE id_inscripcion = v_id_inscripcion;
        END IF;

        -- Recalcula el promedio final dividiendo la suma de los promedios de los trimestres entre la 
        -- cantidad de trimestres con nota registrada para obtener un promedio actualizado
        UPDATE inscripciones_asignaturas
        SET promedio_final = ROUND(
            (
                -- Suma los promedios de los trimestres, usando COALESCE para tratar NULL como 0
                -- Se multiplica por 1 para incluir el trimestre en el cálculo solo si tiene un promedio registrado (no es NULL)
                COALESCE(promedio_t1, 0) * CASE WHEN promedio_t1 IS NOT NULL THEN 1 ELSE 0 END +
                COALESCE(promedio_t2, 0) * CASE WHEN promedio_t2 IS NOT NULL THEN 1 ELSE 0 END +
                COALESCE(promedio_t3, 0) * CASE WHEN promedio_t3 IS NOT NULL THEN 1 ELSE 0 END
                -- Suma = 14.67
            ) /
            NULLIF(
                (
                    -- Cuenta cuántos trimestres tienen un promedio registrado para dividir solo entre esos 
                    -- trimestres y no por 3 si no se han cursado todos
                    CASE WHEN promedio_t1 IS NOT NULL THEN 1 ELSE 0 END +
                    CASE WHEN promedio_t2 IS NOT NULL THEN 1 ELSE 0 END +
                    CASE WHEN promedio_t3 IS NOT NULL THEN 1 ELSE 0 END
                ), 
                0
            ),
            2
        )
        WHERE id_inscripcion = v_id_inscripcion;

        -- Si el promedio final es menor a 6.00 verifica si ya existe una alerta activa de bajo rendimiento para esta inscripción
        IF v_promedio IS NOT NULL AND v_promedio < 6.00 THEN
            SELECT COUNT(*) INTO v_alerta_existe
            FROM alertas_academicas
            WHERE id_inscripcion = v_id_inscripcion
            AND tipo_alerta = 'promedio_bajo'
            AND estado_alerta = 'activa';
            
            -- Si no existe, crea una nueva alerta indicando el promedio y el trimestre que está por debajo del límite de riesgo
            IF v_alerta_existe = 0 THEN
                INSERT INTO alertas_academicas (id_inscripcion, tipo_alerta, descripcion)
                VALUES (
                    v_id_inscripcion,
                    'promedio_bajo',
                    'El estudiante tiene un promedio de ' || v_promedio || ' en el Trimestre ' || v_trimestre || ' (límite mínimo de riesgo: 6.00).'
                );
            -- Si ya existe una alerta activa, solo se actualiza la descripción para reflejar el nuevo promedio y trimestre
            ELSE
                UPDATE alertas_academicas
                SET descripcion = 'El estudiante tiene un promedio de ' || v_promedio || ' en el Trimestre ' || v_trimestre || ' (límite mínimo de riesgo: 6.00).'
                WHERE id_inscripcion = v_id_inscripcion
                AND tipo_alerta = 'promedio_bajo'
                AND estado_alerta = 'activa';
            END IF;
        END IF;

        -- Si el promedio final es 6.00 o superior, resuelve cualquier alerta activa de bajo rendimiento que exista para esta inscripción
        IF v_promedio IS NOT NULL AND v_promedio >= 6.00 THEN
            UPDATE alertas_academicas
            SET estado_alerta = 'resuelta'
            WHERE id_inscripcion = v_id_inscripcion
            AND tipo_alerta = 'promedio_bajo'
            AND estado_alerta = 'activa';
        END IF;
        
        -- Retorna el registro modificado o eliminado según corresponda para continuar con la 
        -- operación de inserción, actualización o eliminación
        IF TG_OP = 'DELETE' THEN
            RETURN OLD;
        ELSE
            RETURN NEW;
        END IF;
    END;
$$;

DROP TRIGGER IF EXISTS trg_actualizar_promedio ON notas;
CREATE TRIGGER trg_actualizar_promedio
AFTER INSERT OR UPDATE OR DELETE ON notas
FOR EACH ROW EXECUTE FUNCTION fn_actualizar_promedio();


-- Evita que un docente, sección o aula coincidan a la misma hora (choque de horario)
CREATE OR REPLACE FUNCTION fn_validar_horario()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_id_personal INT;
        v_id_seccion INT;
        v_id_ano_lectivo INT;
        v_docente_nombre VARCHAR(200);
        v_seccion_letra CHAR(1);
        v_grado_nombre VARCHAR(100);
        v_materia_nombre VARCHAR(100);
    BEGIN
        SELECT ad.id_personal, ad.id_seccion, ad.id_ano_lectivo, p.nombres || ' ' || p.apellidos, s.letra, g.nombre, m.nombre
        INTO v_id_personal, v_id_seccion, v_id_ano_lectivo, v_docente_nombre, v_seccion_letra, v_grado_nombre, v_materia_nombre
        FROM asignaciones_docentes ad
        JOIN personal p ON p.id_personal = ad.id_personal
        JOIN secciones s ON s.id_seccion = ad.id_seccion
        JOIN grados g ON g.id_grado = s.id_grado
        JOIN materias m ON m.id_materia = ad.id_materia
        WHERE ad.id_asignacion_docente = NEW.id_asignacion_docente;

        -- Verifica si el docente tiene otro horario asignado que se solape con el nuevo horario en el mismo día
        IF EXISTS (
            SELECT 1 
            FROM horarios h
            JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = h.id_asignacion_docente
            WHERE ad.id_personal = v_id_personal
            AND ad.id_ano_lectivo = v_id_ano_lectivo
            AND h.dia_semana = NEW.dia_semana
            -- OVERLAPS permite verificar si los intervalos de tiempo se solapan, es decir, si hay un choque de horario entre la nueva 
            -- clase y las clases ya asignadas al docente en ese día.
            AND (NEW.hora_inicio, NEW.hora_fin) OVERLAPS (h.hora_inicio, h.hora_fin)
            -- No se toma en cuenta el horario que se está insertando o actualizando
            AND h.id_horario != COALESCE(NEW.id_horario, -1)
        ) THEN
            RAISE EXCEPTION 'Choque de Horario: El docente % ya tiene asignada una clase en el día y horario solicitado (% - %).',
                v_docente_nombre, NEW.hora_inicio, NEW.hora_fin;
        END IF;

        -- Verifica si la sección ya tiene otro horario asignado que se solape con el nuevo horario en el mismo día
        IF EXISTS (
            SELECT 1 
            FROM horarios h
            JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = h.id_asignacion_docente
            WHERE ad.id_seccion = v_id_seccion
            AND ad.id_ano_lectivo = v_id_ano_lectivo
            AND h.dia_semana = NEW.dia_semana
            AND (NEW.hora_inicio, NEW.hora_fin) OVERLAPS (h.hora_inicio, h.hora_fin)
            AND h.id_horario != COALESCE(NEW.id_horario, -1)
        ) THEN
            RAISE EXCEPTION 'Choque de Sección: El grado y sección % "%" ya tiene clases programadas en el día y horario solicitado (% - %).',
                v_grado_nombre, v_seccion_letra, NEW.hora_inicio, NEW.hora_fin;
        END IF;

        -- Verifica si el aula ya tiene otro horario asignado que se solape con el nuevo horario en el mismo día
        IF EXISTS (
            SELECT 1 
            FROM horarios h
            JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = h.id_asignacion_docente
            WHERE h.aula = NEW.aula
            AND ad.id_ano_lectivo = v_id_ano_lectivo
            AND h.dia_semana = NEW.dia_semana
            AND (NEW.hora_inicio, NEW.hora_fin) OVERLAPS (h.hora_inicio, h.hora_fin)
            AND h.id_horario != COALESCE(NEW.id_horario, -1)
        ) THEN
            RAISE EXCEPTION 'Choque de Aula: El aula "%" ya está ocupada por otra clase en el día y horario solicitado (% - %).',
                NEW.aula, NEW.hora_inicio, NEW.hora_fin;
        END IF;

        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_validar_horario ON horarios;
CREATE TRIGGER trg_validar_horario
BEFORE INSERT OR UPDATE ON horarios
FOR EACH ROW EXECUTE FUNCTION fn_validar_horario();


-- Valida que no se pueda registrar asistencia en un día donde no tenga clase en una materia específica
CREATE OR REPLACE FUNCTION fn_validar_asistencia_fecha()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_id_asignacion_docente INT;
        v_dia_semana INT;
        v_nombre_dia VARCHAR(15);
    BEGIN
        SELECT id_asignacion_docente INTO v_id_asignacion_docente
        FROM inscripciones_asignaturas
        WHERE id_inscripcion = NEW.id_inscripcion;

        -- EXTRACT(ISODOW FROM fecha) devuelve el número del día de la semana
        -- ISODOW se usa para que la semana empiece en lunes y termine en domingo (1 para lunes, 2 para martes, ..., 7 para domingo)
        v_dia_semana := EXTRACT(ISODOW FROM NEW.fecha);

        -- Verifica si existe un horario programado para la asignatura en el día de la semana de la fecha de asistencia
        IF NOT EXISTS (
            SELECT 1 FROM horarios
            WHERE id_asignacion_docente = v_id_asignacion_docente
            AND dia_semana = v_dia_semana
        ) THEN
            -- Mapea el número del día de la semana a su nombre para mostrar un mensaje de error claro
            v_nombre_dia := CASE v_dia_semana
                WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miércoles'
                WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' WHEN 6 THEN 'Sábado'
                WHEN 7 THEN 'Domingo'
            END;
            RAISE EXCEPTION 'Error de Asistencia: No se puede registrar asistencia en la fecha % (%). No hay horario programado para esta asignatura en este día.',
                NEW.fecha, v_nombre_dia;
        END IF;

        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_validar_asistencia_fecha ON asistencias;
CREATE TRIGGER trg_validar_asistencia_fecha
BEFORE INSERT OR UPDATE ON asistencias
FOR EACH ROW EXECUTE FUNCTION fn_validar_asistencia_fecha();

-- Evita que se le asigne más de una materia a un mismo docente en el mismo año lectivo
CREATE OR REPLACE FUNCTION fn_validar_especialidad_docente()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_materia_nombre VARCHAR(100);
    BEGIN
        SELECT m.nombre INTO v_materia_nombre
        FROM asignaciones_docentes ad
        JOIN materias m ON m.id_materia = ad.id_materia
        WHERE ad.id_personal = NEW.id_personal
        AND ad.id_ano_lectivo = NEW.id_ano_lectivo
        AND ad.id_materia != NEW.id_materia
        LIMIT 1; -- Basta con encontrar una asignación para lanzar la excepción
        
        -- Si se encontró alguna asignación del docente en otra materia del mismo año, se lanza una excepción
        IF FOUND THEN
            RAISE EXCEPTION 'Restricción de Docente: El docente seleccionado ya tiene asignada la materia "%" en este año lectivo. Cada docente se enfoca en una sola materia.',
                v_materia_nombre;
        END IF;

        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_validar_especialidad_docente ON asignaciones_docentes;
CREATE TRIGGER trg_validar_especialidad_docente
BEFORE INSERT OR UPDATE ON asignaciones_docentes
FOR EACH ROW EXECUTE FUNCTION fn_validar_especialidad_docente();


-- Evita que un estudiante se inscriba en una asignatura que no corresponde a su sección o año lectivo
CREATE OR REPLACE FUNCTION fn_validar_inscripcion_seccion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_seccion_mat INT;
        v_ano_mat INT;
        v_seccion_asig INT;
        v_ano_asig INT;
    BEGIN
        SELECT id_seccion, id_ano_lectivo INTO v_seccion_mat, v_ano_mat
        FROM matriculas WHERE id_matricula = NEW.id_matricula;

        SELECT id_seccion, id_ano_lectivo INTO v_seccion_asig, v_ano_asig
        FROM asignaciones_docentes WHERE id_asignacion_docente = NEW.id_asignacion_docente;

        -- Si la sección o el año lectivo de la matrícula no coinciden con los de la asignatura, se lanza 
        -- una excepción para evitar la inscripción
        IF v_seccion_mat != v_seccion_asig OR v_ano_mat != v_ano_asig THEN
            RAISE EXCEPTION 'Conflicto de Inscripción: Estudiante pertenece a la sección % (Año %), pero la asignatura corresponde a la sección % (Año %).',
                v_seccion_mat, v_ano_mat, v_seccion_asig, v_ano_asig;
        END IF;

        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_validar_inscripcion_seccion ON inscripciones_asignaturas;
CREATE TRIGGER trg_validar_inscripcion_seccion
BEFORE INSERT OR UPDATE ON inscripciones_asignaturas
FOR EACH ROW EXECUTE FUNCTION fn_validar_inscripcion_seccion();


-- Asegura que solo se puedan registrar notas o asistencias a alumnos con una inscripción activa en la asignatura.
CREATE OR REPLACE FUNCTION fn_validar_estado_inscripcion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_estado VARCHAR(15);
    BEGIN
        SELECT estado INTO v_estado
        FROM inscripciones_asignaturas
        WHERE id_inscripcion = NEW.id_inscripcion;
        
        -- Si el estado de la inscripción no es 'activa', se lanza una excepción para evitar registrar notas o asistencias
        IF v_estado != 'activa' THEN
            RAISE EXCEPTION 'Inscripción Inactiva: No se permite registrar notas o asistencia porque el estado de la asignatura es "%".', v_estado;
        END IF;

        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_validar_asistencia_estado ON asistencias;
CREATE TRIGGER trg_validar_asistencia_estado
BEFORE INSERT OR UPDATE ON asistencias
FOR EACH ROW EXECUTE FUNCTION fn_validar_estado_inscripcion();

DROP TRIGGER IF EXISTS trg_validar_nota_estado ON notas;
CREATE TRIGGER trg_validar_nota_estado
BEFORE INSERT OR UPDATE ON notas
FOR EACH ROW EXECUTE FUNCTION fn_validar_estado_inscripcion();


-- Crea alertas si las inasistencias superan el 25% de clases, o las resuelve si baja de ese límite
CREATE OR REPLACE FUNCTION fn_actualizar_alertas_asistencia()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE
        v_id_inscripcion INT;
        v_total_sesiones INT;
        v_ausencias INT;
        v_porcentaje NUMERIC(5,2);
        v_alerta_existe INT;
    BEGIN
        v_id_inscripcion := NEW.id_inscripcion;

        SELECT COUNT(*), COUNT(*) FILTER (WHERE tipo_asistencia = 'ausente')
        INTO v_total_sesiones, v_ausencias
        FROM asistencias
        WHERE id_inscripcion = v_id_inscripcion;

        -- Solo se hacen los procesos si el estudiante tiene al menos una sesión registrada
        IF v_total_sesiones > 0 THEN
            v_porcentaje := (v_ausencias * 100.0) / v_total_sesiones;
            
            -- Si el porcentaje de ausencias supera el 25% (límite de faltas aceptables)
            IF v_porcentaje > 25.00 THEN
                -- Se verifica si ya existe una alerta activa
                SELECT COUNT(*) INTO v_alerta_existe
                FROM alertas_academicas
                WHERE id_inscripcion = v_id_inscripcion
                AND tipo_alerta = 'inasistencia_excesiva'
                AND estado_alerta = 'activa';

                -- Si no existe una alerta activa, se crea una nueva alerta
                IF v_alerta_existe = 0 THEN
                    INSERT INTO alertas_academicas (id_inscripcion, tipo_alerta, descripcion)
                    VALUES (
                        v_id_inscripcion,
                        'inasistencia_excesiva',
                        'Alerta de Asistencia: El estudiante supera el 25% de ausencias (' || ROUND(v_porcentaje, 2) || '% de ausencias en ' || v_total_sesiones || ' clases).'
                    );
                ELSE
                    -- Si ya existe una alerta activa, solo se actualiza la descripción
                    UPDATE alertas_academicas
                    SET descripcion = 'Alerta de Asistencia: El estudiante supera el 25% de ausencias (' || ROUND(v_porcentaje, 2) || '% de ausencias en ' || v_total_sesiones || ' clases).'
                    WHERE id_inscripcion = v_id_inscripcion
                    AND tipo_alerta = 'inasistencia_excesiva'
                    AND estado_alerta = 'activa';
                END IF;
            ELSE
                -- Si el porcentaje de ausencias baja al 25% o menos, se resuelven las alertas activas de inasistencia
                UPDATE alertas_academicas
                SET estado_alerta = 'resuelta'
                WHERE id_inscripcion = v_id_inscripcion
                AND tipo_alerta = 'inasistencia_excesiva'
                AND estado_alerta = 'activa';
            END IF;
        END IF;

        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_actualizar_alertas_asistencia ON asistencias;
CREATE TRIGGER trg_actualizar_alertas_asistencia
AFTER INSERT OR UPDATE OR DELETE ON asistencias
FOR EACH ROW EXECUTE FUNCTION fn_actualizar_alertas_asistencia();


-- Almacena el historial de inserción, actualización y eliminación de calificaciones
CREATE OR REPLACE FUNCTION fn_auditoria_notas()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    BEGIN
        -- Se verifica la operación para acceder a los valores OLD o NEW según corresponda
        -- y a partir de eso se inserta un registro
        IF TG_OP = 'INSERT' THEN
            INSERT INTO auditoria_notas
                (id_nota, id_inscripcion, id_evaluacion, operacion, nota_anterior, nota_nueva)
            VALUES
                (NEW.id_nota, NEW.id_inscripcion, NEW.id_evaluacion, 'INSERT', NULL, NEW.nota);
        ELSIF TG_OP = 'UPDATE' THEN
            INSERT INTO auditoria_notas
                (id_nota, id_inscripcion, id_evaluacion, operacion, nota_anterior, nota_nueva)
            VALUES
                (NEW.id_nota, NEW.id_inscripcion, NEW.id_evaluacion, 'UPDATE', OLD.nota, NEW.nota);
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO auditoria_notas
                (id_nota, id_inscripcion, id_evaluacion, operacion, nota_anterior, nota_nueva)
            VALUES
                (OLD.id_nota, OLD.id_inscripcion, OLD.id_evaluacion, 'DELETE', OLD.nota, NULL);
        END IF;
        RETURN NEW;
    END;
$$;

DROP TRIGGER IF EXISTS trg_auditoria_notas ON notas;
CREATE TRIGGER trg_auditoria_notas
AFTER INSERT OR UPDATE OR DELETE ON notas
FOR EACH ROW EXECUTE FUNCTION fn_auditoria_notas();


-- Respalda la información de la inscripción de asignaturas antes de que sea eliminada.
CREATE OR REPLACE FUNCTION fn_respaldo_inscripcion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    BEGIN
        INSERT INTO respaldo_inscripciones
            (
                id_inscripcion, 
                id_matricula, 
                id_asignacion_docente, 
                promedio_t1, 
                promedio_t2, 
                promedio_t3, 
                promedio_final, 
                estado
            )
        VALUES
            (
                OLD.id_inscripcion, 
                OLD.id_matricula, 
                OLD.id_asignacion_docente, 
                OLD.promedio_t1, 
                OLD.promedio_t2, 
                OLD.promedio_t3, 
                OLD.promedio_final, OLD.estado
            );
        
        RETURN OLD;
    END;
$$;

DROP TRIGGER IF EXISTS trg_respaldo_inscription ON inscripciones_asignaturas;
CREATE TRIGGER trg_respaldo_inscription
BEFORE DELETE ON inscripciones_asignaturas
FOR EACH ROW EXECUTE FUNCTION fn_respaldo_inscripcion();


-- Registra la nota de un estudiante realizando un UPSERT para insertar la nota o actualizarla si ya existía para esa evaluación
CREATE OR REPLACE PROCEDURE registrar_nota(
    -- Parámetros:
    p_id_inscripcion INT, -- ID de la inscripción del estudiante en la asignatura
    p_id_evaluacion INT, -- ID de la evaluación (por ejemplo, examen, tarea, etc.)
    p_nota NUMERIC(4,2)
)
LANGUAGE plpgsql
AS $$
    BEGIN
        -- El comando INSERT INTO ... ON CONFLICT se utiliza para realizar un UPSERT
        -- básicamente es insertar una nueva nota o actualizarla si ya existe una nota para la misma inscripción y evaluación
        INSERT INTO notas (id_inscripcion, id_evaluacion, nota)
        VALUES (p_id_inscripcion, p_id_evaluacion, p_nota)
        ON CONFLICT (id_inscripcion, id_evaluacion)
        DO UPDATE SET nota = EXCLUDED.nota, fecha_registro = CURRENT_TIMESTAMP;
    END;
$$;

-- Ejemplo
-- Registrar o actualizar la nota 8.50 para la inscripción con id_inscripcion = 15 (estudiante de 1° grado sección A)
--  en la evaluación con id_evaluacion = 5 (Proyecto del Trimestre, Trimestre 2 de Idioma Extranjero Inglés 1°)
-- CALL registrar_nota(15, 5, 8.50);


-- Registra la asistencia en estado "presente" para todos los estudiantes inscritos activos en la asignatura 
-- del docente en la fecha indicada (caso en que todos los estudiantes están presentes)
CREATE OR REPLACE PROCEDURE registrar_asistencia_seccion(
    p_id_asignacion_docente INT, -- ID de la asignación docente para identificar la asignatura y sección
    p_fecha DATE DEFAULT CURRENT_DATE, -- Fecha para la cual se registrará la asistencia, por defecto es la fecha actual
    p_tipo_default VARCHAR(15) DEFAULT 'presente' -- Tipo de asistencia a registrar para todos los estudiantes, por defecto es "presente"
)
LANGUAGE plpgsql
AS $$
    DECLARE
        v_insc RECORD;
    BEGIN
        FOR v_insc IN
            SELECT id_inscripcion
            FROM inscripciones_asignaturas
            WHERE id_asignacion_docente = p_id_asignacion_docente
            AND estado = 'activa'
        LOOP
            INSERT INTO asistencias (id_inscripcion, fecha, tipo_asistencia)
            VALUES (v_insc.id_inscripcion, p_fecha, p_tipo_default)
            ON CONFLICT (id_inscripcion, fecha) DO NOTHING;
        END LOOP;
    END;
$$;

-- Ejemplo
-- Registra asistencia para la asignatura del docente con id_asignacion_docente = 10 
--(Victoria Martínez - Idioma Extranjero Inglés 1°, 1° grado sección B)
-- en la fecha '2026-06-01' (en formato 'YYYY-MM-DD') marcando a todos los estudiantes como "presente"
-- CALL registrar_asistencia_seccion(10, '2026-06-01', 'presente');


-- A partir del nie del estudiante y el nombre de la materia, obtiene el promedio final actualizado 
-- y la situación académica del estudiante en esa materia
CREATE OR REPLACE FUNCTION obtener_reporte_estudiante_materia(
    -- Parámetros:
    p_nie_estudiante VARCHAR(20), -- NIE del estudiante para identificarlo
    p_nombre_materia VARCHAR(100) -- Nombre de la materia para filtrar el reporte
)
-- Retorna una tabla para ver el reporte
RETURNS TABLE (
    grado VARCHAR(100),
    seccion CHAR(1),
    anio_lectivo INT,
    materia VARCHAR(100),
    estudiante VARCHAR(200),
    promedio_final NUMERIC(4,2),
    estado_inscripcion VARCHAR(15),
    situacion_academica VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
    BEGIN
        -- Return Query indica que la función va a retornar el resultado de la consulta que se le asigna
        RETURN QUERY
        SELECT
        g.nombre AS grado,
        s.letra AS seccion,
        al.anio AS anio_lectivo,
        m.nombre AS materia,
        e.nombres || ' ' || e.apellidos AS estudiante,
        ia.promedio_final,
        ia.estado AS estado_inscripcion,
        CASE
            WHEN ia.promedio_final IS NULL THEN 'Sin Promedio'
            WHEN ia.promedio_final >= 6.00 THEN 'Aprobado'
            WHEN ia.promedio_final >= 5.00 THEN 'Aprobado (En Riesgo)'
            ELSE 'Reprobado (Riesgo Alto)'
        END AS situacion_academica
        FROM inscripciones_asignaturas ia
        JOIN matriculas mt ON mt.id_matricula = ia.id_matricula
        JOIN estudiantes e ON e.id_estudiante = mt.id_estudiante
        JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = ia.id_asignacion_docente
        JOIN materias m ON m.id_materia = ad.id_materia
        JOIN secciones s ON s.id_seccion = mt.id_seccion
        JOIN grados g ON g.id_grado = s.id_grado
        JOIN anos_lectivos al ON al.id_ano_lectivo = mt.id_ano_lectivo
        WHERE e.nie = p_nie_estudiante
        AND m.nombre = p_nombre_materia;
    END;
$$;

-- Ejemplo
-- Estudiante de 5° grado sección B con NIE "NIE00025" inscrito en "Matemáticas 5°"
--SELECT * FROM obtener_reporte_estudiante_materia('NIE00025', 'Matemáticas 5°');