-- Limpieza de tablas previas
DROP TABLE IF EXISTS respaldo_inscripciones CASCADE;
DROP TABLE IF EXISTS auditoria_notas CASCADE;
DROP TABLE IF EXISTS alertas_academicas CASCADE;
DROP TABLE IF EXISTS asistencias CASCADE;
DROP TABLE IF EXISTS notas CASCADE;
DROP TABLE IF EXISTS evaluaciones CASCADE;
DROP TABLE IF EXISTS inscripciones_asignaturas CASCADE;
DROP TABLE IF EXISTS horarios CASCADE;
DROP TABLE IF EXISTS asignaciones_docentes CASCADE;
DROP TABLE IF EXISTS materias CASCADE;
DROP TABLE IF EXISTS personal CASCADE;
DROP TABLE IF EXISTS matriculas CASCADE;
DROP TABLE IF EXISTS estudiantes CASCADE;
DROP TABLE IF EXISTS secciones CASCADE;
DROP TABLE IF EXISTS grados CASCADE;
DROP TABLE IF EXISTS anos_lectivos CASCADE;

-- Tabla anos_lectivos
CREATE TABLE anos_lectivos (
    id_ano_lectivo SERIAL PRIMARY KEY,
    anio INT NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    CONSTRAINT uq_anos_lectivos_anio UNIQUE (anio),
    CONSTRAINT chk_anos_lectivos_anio CHECK (anio >= 2000),
    CONSTRAINT chk_anos_lectivos_fechas CHECK (fecha_fin > fecha_inicio)
);

-- Asegura un solo año lectivo activo
CREATE UNIQUE INDEX idx_unico_ano_lectivo_activo 
ON anos_lectivos (activo) 
WHERE (activo = TRUE);

-- Tabla grados
CREATE TABLE grados (
    id_grado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nivel VARCHAR(20)  NOT NULL,
    orden INT  NOT NULL,
    CONSTRAINT uq_grados_nombre UNIQUE (nombre),
    CONSTRAINT chk_grados_nivel CHECK (nivel IN ('parvularia', 'basica', 'media')),
    CONSTRAINT chk_grados_orden CHECK (orden >= 0)
);

-- Tabla secciones
CREATE TABLE secciones (
    id_seccion SERIAL PRIMARY KEY,
    id_grado INT NOT NULL REFERENCES grados(id_grado) ON DELETE CASCADE,
    id_ano_lectivo INT NOT NULL REFERENCES anos_lectivos(id_ano_lectivo) ON DELETE CASCADE,
    letra CHAR(1) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    CONSTRAINT uq_secciones_grado_ano_letra UNIQUE (id_grado, id_ano_lectivo, letra),
    CONSTRAINT chk_secciones_letra CHECK (letra ~ '^[A-Z]$'),
    CONSTRAINT chk_secciones_turno CHECK (turno IN ('Mañana', 'Tarde', 'Completo'))
);

-- Tabla estudiantes
CREATE TABLE estudiantes (
    id_estudiante SERIAL PRIMARY KEY,
    nie VARCHAR(20) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) NOT NULL,
    es_repitente BOOLEAN NOT NULL DEFAULT FALSE,
    tiene_extraedad BOOLEAN NOT NULL DEFAULT FALSE,
    pertenece_dai BOOLEAN NOT NULL DEFAULT FALSE,
    actividad_economica VARCHAR(50) NOT NULL DEFAULT 'No trabaja',
    convivencia VARCHAR(50) NOT NULL DEFAULT 'Vive con ambos',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_estudiantes_nie UNIQUE (nie),
    CONSTRAINT chk_estudiantes_genero CHECK (genero IN ('M', 'F')),
    CONSTRAINT chk_estudiantes_fecha_nac CHECK (fecha_nacimiento < CURRENT_DATE)
);

-- Tabla matriculas
CREATE TABLE matriculas (
    id_matricula SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE,
    id_seccion INT NOT NULL REFERENCES secciones(id_seccion) ON DELETE CASCADE,
    id_ano_lectivo INT NOT NULL REFERENCES anos_lectivos(id_ano_lectivo) ON DELETE CASCADE,
    tipo_inscripcion CHAR(1) NOT NULL,
    fecha_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
    estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVA',
    CONSTRAINT uq_matriculas_estudiante_ano UNIQUE (id_estudiante, id_ano_lectivo),
    CONSTRAINT chk_matriculas_tipo CHECK (tipo_inscripcion IN ('V', 'N', 'T')),
    CONSTRAINT chk_matriculas_estado CHECK (estado IN ('ACTIVA', 'RETIRADA', 'TRASLADADA'))
);

-- Tabla personal (docentes)
CREATE TABLE personal (
    id_personal SERIAL PRIMARY KEY,
    dui VARCHAR(10) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    telefono VARCHAR(20),
    especialidad VARCHAR(100) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uq_personal_dui UNIQUE (dui),
    CONSTRAINT uq_personal_correo UNIQUE (correo),
    CONSTRAINT chk_personal_dui CHECK (dui ~ '^[0-9]{8}-[0-9]$')
);

-- Tabla materias
CREATE TABLE materias (
    id_materia SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    id_grado INT NOT NULL REFERENCES grados(id_grado) ON DELETE CASCADE,
    CONSTRAINT uq_materias_codigo UNIQUE (codigo)
);

-- Tabla asignaciones_docentes
CREATE TABLE asignaciones_docentes (
    id_asignacion_docente SERIAL PRIMARY KEY,
    id_personal INT NOT NULL REFERENCES personal(id_personal) ON DELETE CASCADE,
    id_materia INT NOT NULL REFERENCES materias(id_materia) ON DELETE CASCADE,
    id_seccion INT NOT NULL REFERENCES secciones(id_seccion) ON DELETE CASCADE,
    id_ano_lectivo INT NOT NULL REFERENCES anos_lectivos(id_ano_lectivo) ON DELETE CASCADE,
    CONSTRAINT uq_asignaciones_materia_seccion_ano UNIQUE (id_materia, id_seccion, id_ano_lectivo)
);

-- Tabla horarios
CREATE TABLE horarios (
    id_horario SERIAL PRIMARY KEY,
    id_asignacion_docente INT NOT NULL REFERENCES asignaciones_docentes(id_asignacion_docente) ON DELETE CASCADE,
    dia_semana INT NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    aula  VARCHAR(30) NOT NULL,
    CONSTRAINT chk_horarios_dia CHECK (dia_semana BETWEEN 1 AND 7),
    CONSTRAINT chk_horarios_horas CHECK (hora_fin > hora_inicio)
);

-- Tabla inscripciones_asignaturas
CREATE TABLE inscripciones_asignaturas (
    id_inscripcion SERIAL PRIMARY KEY,
    id_matricula INT NOT NULL REFERENCES matriculas(id_matricula) ON DELETE CASCADE,
    id_asignacion_docente INT NOT NULL REFERENCES asignaciones_docentes(id_asignacion_docente) ON DELETE CASCADE,
    promedio_t1 NUMERIC(4,2) DEFAULT NULL,
    promedio_t2 NUMERIC(4,2) DEFAULT NULL,
    promedio_t3 NUMERIC(4,2) DEFAULT NULL,
    promedio_final NUMERIC(4,2) DEFAULT NULL,
    estado   VARCHAR(15) NOT NULL DEFAULT 'activa',
    CONSTRAINT uq_insc_mat_asig UNIQUE (id_matricula, id_asignacion_docente),
    CONSTRAINT chk_insc_promedio_t1 CHECK (promedio_t1 IS NULL OR (promedio_t1 >= 0 AND promedio_t1 <= 10)),
    CONSTRAINT chk_insc_promedio_t2 CHECK (promedio_t2 IS NULL OR (promedio_t2 >= 0 AND promedio_t2 <= 10)),
    CONSTRAINT chk_insc_promedio_t3 CHECK (promedio_t3 IS NULL OR (promedio_t3 >= 0 AND promedio_t3 <= 10)),
    CONSTRAINT chk_insc_promedio_fin CHECK (promedio_final IS NULL OR (promedio_final >= 0 AND promedio_final <= 10)),
    CONSTRAINT chk_insc_estado CHECK (estado IN ('activa', 'retirada', 'bloqueada'))
);

-- Tabla evaluaciones
CREATE TABLE evaluaciones (
    id_evaluacion SERIAL PRIMARY KEY,
    id_asignacion_docente INT NOT NULL REFERENCES asignaciones_docentes(id_asignacion_docente) ON DELETE CASCADE,
    trimestre INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    peso_porcentual NUMERIC(5,2) NOT NULL,
    fecha_evaluacion DATE,
    CONSTRAINT uq_evaluaciones_asig_tri_nom UNIQUE (id_asignacion_docente, trimestre, nombre),
    CONSTRAINT chk_evaluaciones_trimestre CHECK (trimestre IN (1, 2, 3)),
    CONSTRAINT chk_evaluaciones_tipo CHECK (tipo IN ('examen', 'tarea', 'proyecto', 'participacion', 'laboratorio', 'cuaderno')),
    CONSTRAINT chk_evaluaciones_peso CHECK (peso_porcentual > 0 AND peso_porcentual <= 100)
);

-- Tabla notas
CREATE TABLE notas (
    id_nota SERIAL PRIMARY KEY,
    id_inscripcion INT NOT NULL REFERENCES inscripciones_asignaturas(id_inscripcion) ON DELETE CASCADE,
    id_evaluacion INT NOT NULL REFERENCES evaluaciones(id_evaluacion) ON DELETE CASCADE,
    nota NUMERIC(4,2) NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_notas_insc_eval UNIQUE (id_inscripcion, id_evaluacion),
    CONSTRAINT chk_notas_valor CHECK (nota >= 0 AND nota <= 10)
);

-- Tabla asistencias
CREATE TABLE asistencias (
    id_asistencia SERIAL PRIMARY KEY,
    id_inscripcion INT NOT NULL REFERENCES inscripciones_asignaturas(id_inscripcion) ON DELETE CASCADE,
    fecha DATE NOT NULL,
    tipo_asistencia VARCHAR(15) NOT NULL DEFAULT 'presente',
    observacion TEXT,
    CONSTRAINT uq_asistencias_insc_fecha UNIQUE (id_inscripcion, fecha),
    CONSTRAINT chk_asistencias_tipo CHECK (tipo_asistencia IN ('presente', 'ausente', 'justificada', 'tardanza')),
    CONSTRAINT chk_asistencias_fecha CHECK (fecha <= CURRENT_DATE)
);

-- Tabla alertas_academicas
CREATE TABLE alertas_academicas (
    id_alerta SERIAL PRIMARY KEY,
    id_inscripcion INT NOT NULL REFERENCES inscripciones_asignaturas(id_inscripcion) ON DELETE CASCADE,
    tipo_alerta VARCHAR(30) NOT NULL,
    fecha_alerta TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_alerta VARCHAR(15) NOT NULL DEFAULT 'activa',
    descripcion TEXT,
    CONSTRAINT chk_alertas_tipo CHECK (tipo_alerta IN ('promedio_bajo', 'inasistencia_excesiva')),
    CONSTRAINT chk_alertas_estado CHECK (estado_alerta IN ('activa', 'resuelta'))
);

-- Tabla auditoria_notas
CREATE TABLE auditoria_notas (
    id_auditoria SERIAL PRIMARY KEY,
    id_nota INT,
    id_inscripcion INT,
    id_evaluacion INT,
    operacion VARCHAR(10) NOT NULL,
    nota_anterior NUMERIC(4,2),
    nota_nueva NUMERIC(4,2),
    usuario_bd VARCHAR(80) NOT NULL DEFAULT CURRENT_USER,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_auditoria_operacion CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- Tabla respaldo_inscripciones
CREATE TABLE respaldo_inscripciones (
    id_respaldo SERIAL PRIMARY KEY,
    id_inscripcion INT,
    id_matricula INT,
    id_asignacion_docente INT,
    promedio_t1 NUMERIC(4,2),
    promedio_t2 NUMERIC(4,2),
    promedio_t3 NUMERIC(4,2),
    promedio_final NUMERIC(4,2),
    estado VARCHAR(15),
    eliminado_por VARCHAR(80) DEFAULT CURRENT_USER,
    fecha_eliminacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimizar rendimiento
CREATE INDEX idx_matriculas_seccion_ano ON matriculas (id_seccion, id_ano_lectivo);
CREATE INDEX idx_notas_inscripcion ON notas (id_inscripcion);
CREATE INDEX idx_asistencias_fecha ON asistencias (fecha);
CREATE INDEX idx_horarios_asignacion ON horarios (id_asignacion_docente);
