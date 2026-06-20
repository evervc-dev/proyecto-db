-- Genera un reporte completo del rendimiento académico de cada estudiante desglosado por trimestre
CREATE OR REPLACE VIEW v_desempeno_estudiantes AS
SELECT
    e.nie,
    e.nombres || ' ' || e.apellidos AS estudiante_nombre,
    g.nombre AS grado,
    s.letra AS seccion,
    al.anio AS anio_lectivo,
    m.nombre AS materia,
    p.nombres || ' ' || p.apellidos AS docente,
    ia.promedio_t1,
    ia.promedio_t2,
    ia.promedio_t3,
    ia.promedio_final,
    ia.estado AS estado_inscripcion,
    CASE
        -- En base al promedio final determina la situación académica del estudiante
        WHEN ia.promedio_final IS NULL THEN 'Sin Promedio'
        WHEN ia.promedio_final >= 6.00 THEN 'Aprobado'
        WHEN ia.promedio_final >= 5.00 THEN 'Aprobado (En Riesgo)'
        ELSE 'Reprobado (Riesgo Alto)'
    END AS situacion_academica
FROM inscripciones_asignaturas ia
JOIN matriculas mt ON mt.id_matricula = ia.id_matricula
JOIN estudiantes e ON e.id_estudiante = mt.id_estudiante
JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = ia.id_asignacion_docente
JOIN personal p ON p.id_personal = ad.id_personal
JOIN materias m ON m.id_materia = ad.id_materia
JOIN secciones s ON s.id_seccion = mt.id_seccion
JOIN grados g ON g.id_grado = s.id_grado
JOIN anos_lectivos al ON al.id_ano_lectivo = mt.id_ano_lectivo;

-- Determina el total de sesiones de clase y calcula los porcentajes de inasistencias de cada estudiante por materia
CREATE OR REPLACE VIEW v_reporte_asistencia AS
SELECT
    g.nombre AS grado,
    s.letra AS seccion,
    al.anio AS anio_lectivo,
    m.nombre AS materia,
    e.nie,
    e.nombres || ' ' || e.apellidos AS estudiante,
    COUNT(ast.id_asistencia) AS total_sesiones,
    COUNT(ast.id_asistencia) FILTER (WHERE ast.tipo_asistencia = 'presente') AS presentes,
    COUNT(ast.id_asistencia) FILTER (WHERE ast.tipo_asistencia = 'ausente') AS ausentes,
    COUNT(ast.id_asistencia) FILTER (WHERE ast.tipo_asistencia = 'justificada') AS justificadas,
    COUNT(ast.id_asistencia) FILTER (WHERE ast.tipo_asistencia = 'tardanza') AS tardanzas,
    ROUND(
        -- Calcula el porcentaje de ausencias sobre el total de sesiones, multiplicado por 100 para obtener el porcentaje
        -- FILTER se utiliza para contar solo las ausencias
        COUNT(ast.id_asistencia) FILTER (WHERE ast.tipo_asistencia = 'ausente') * 100.0
        / NULLIF(COUNT(ast.id_asistencia), 0), -- NULLIF evita división por cero, devuelve NULL si total_sesiones es 0
        2 -- Redondea el resultado a 2 decimales
    ) AS porcentaje_ausencias
FROM asistencias ast
JOIN inscripciones_asignaturas ia ON ia.id_inscripcion = ast.id_inscripcion
JOIN matriculas mt ON mt.id_matricula = ia.id_matricula
JOIN estudiantes e ON e.id_estudiante = mt.id_estudiante
JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = ia.id_asignacion_docente
JOIN materias m ON m.id_materia = ad.id_materia
JOIN secciones s ON s.id_seccion = mt.id_seccion
JOIN grados g ON g.id_grado = s.id_grado
JOIN anos_lectivos al ON al.id_ano_lectivo = mt.id_ano_lectivo
GROUP BY g.nombre, s.letra, al.anio, m.nombre, e.nie, e.nombres, e.apellidos;

-- Muestra el listado de alertas académicas activas (bajo rendimiento o inasistencias) ordenado por fecha de forma descendente
CREATE OR REPLACE VIEW v_alertas_activas AS
SELECT
    aa.id_alerta,
    e.nie,
    e.nombres || ' ' || e.apellidos AS estudiante,
    g.nombre AS grado,
    s.letra AS seccion,
    m.nombre AS materia,
    al.anio AS anio_lectivo,
    aa.tipo_alerta,
    aa.fecha_alerta,
    aa.descripcion,
    aa.estado_alerta
FROM alertas_academicas aa
JOIN inscripciones_asignaturas ia ON ia.id_inscripcion = aa.id_inscripcion
JOIN matriculas mt ON mt.id_matricula = ia.id_matricula
JOIN estudiantes e ON e.id_estudiante = mt.id_estudiante
JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = ia.id_asignacion_docente
JOIN materias m ON m.id_materia = ad.id_materia
JOIN secciones s ON s.id_seccion = mt.id_seccion
JOIN grados g ON g.id_grado = s.id_grado
JOIN anos_lectivos al ON al.id_ano_lectivo = mt.id_ano_lectivo
WHERE aa.estado_alerta = 'activa'
ORDER BY aa.fecha_alerta DESC;

-- Muestra el horario escolar detallado con los nombres de los días
CREATE OR REPLACE VIEW v_horarios_detallados AS
SELECT
    h.id_horario,
    al.anio AS anio_lectivo,
    g.nombre AS grado,
    s.letra AS seccion,
    m.nombre AS materia,
    p.nombres || ' ' || p.apellidos AS docente,
    CASE h.dia_semana
        -- Mapea el número del día de la semana a su nombre con un
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END AS dia_nombre,
    h.hora_inicio,
    h.hora_fin,
    h.aula
FROM horarios h
JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = h.id_asignacion_docente
JOIN personal p ON p.id_personal = ad.id_personal
JOIN materias m ON m.id_materia = ad.id_materia
JOIN secciones s ON s.id_seccion = ad.id_seccion
JOIN grados g ON g.id_grado = s.id_grado
JOIN anos_lectivos al ON al.id_ano_lectivo = ad.id_ano_lectivo
ORDER BY al.anio, g.orden, s.letra, h.dia_semana, h.hora_inicio;
