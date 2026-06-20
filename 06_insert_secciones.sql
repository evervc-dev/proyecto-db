-- Secciones (año lectivo 2026)
INSERT INTO secciones (id_seccion, id_grado, id_ano_lectivo, letra, turno) VALUES
(1,  3,  5, 'A', 'Mañana'),
(2,  3,  5, 'B', 'Tarde'),
(9,  7,  5, 'A', 'Mañana'),
(10, 7,  5, 'B', 'Tarde'),
(15, 11, 5, 'A', 'Completo'),
(16, 11, 5, 'B', 'Completo');

SELECT setval('secciones_id_seccion_seq', 16);
