-- Inscripciones de asignaturas
-- Se insertan en base a las matriculas activas y asignaciones docentes, de modo que el ID de 
-- matrícula 5 se inscribirá en las 5 asignaturas del grado 1° A, el ID de matrícula 17 se inscribirá en las 5 asignaturas del grado 5° A, etc.
INSERT INTO inscripciones_asignaturas (id_matricula, id_asignacion_docente, estado)
SELECT 
    m.id_matricula,
    ad.id_asignacion_docente,
    'activa'
FROM matriculas m
JOIN asignaciones_docentes ad ON ad.id_seccion = m.id_seccion AND ad.id_ano_lectivo = m.id_ano_lectivo
ORDER BY m.id_matricula, ad.id_asignacion_docente;

SELECT setval('inscripciones_asignaturas_id_inscripcion_seq', (SELECT MAX(id_inscripcion) FROM inscripciones_asignaturas));
