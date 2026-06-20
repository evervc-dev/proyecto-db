-- Grados
INSERT INTO grados (id_grado, nombre, nivel, orden) VALUES
(1,  'Parvularia 5 Años', 'parvularia', 1),
(2,  'Parvularia 6 Años', 'parvularia', 2),
(3,  '1° Grado',          'basica',     3),
(4,  '2° Grado',          'basica',     4),
(5,  '3° Grado',          'basica',     5),
(6,  '4° Grado',          'basica',     6),
(7,  '5° Grado',          'basica',     7),
(8,  '6° Grado',          'basica',     8),
(9,  '7° Grado',          'basica',     9),
(10, '8° Grado',          'basica',     10),
(11, '9° Grado',          'basica',     11);

SELECT setval('grados_id_grado_seq', 11);
