-- Datos de alertas_academicas (históricas/resueltas)
INSERT INTO alertas_academicas (id_alerta, id_inscripcion, tipo_alerta, fecha_alerta, estado_alerta, descripcion) VALUES
(1001, 1,  'promedio_bajo',         '2026-02-10 08:00:00', 'resuelta', 'Bajo rendimiento inicial en pruebas cortas, resuelto tras tutoría grupal.'),
(1002, 5,  'inasistencia_excesiva', '2026-02-12 09:30:00', 'resuelta', 'Ausencias consecutivas por problemas de salud justificadas por constancia médica.'),
(1003, 9,  'promedio_bajo',         '2026-02-10 08:30:00', 'resuelta', 'Bajo rendimiento en el primer laboratorio de ciencias, superado con tareas extras.'),
(1004, 13, 'inasistencia_excesiva', '2026-02-12 09:45:00', 'resuelta', 'Inasistencias justificadas por viaje familiar autorizado por dirección.');

SELECT setval('alertas_academicas_id_alerta_seq', COALESCE((SELECT MAX(id_alerta) FROM alertas_academicas), 1));
