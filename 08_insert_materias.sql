-- Materias básicas
INSERT INTO materias (id_materia, nombre, codigo, id_grado) VALUES
-- 1° Grado
(21, 'Matemáticas 1°',             'MAT-1', 3),
(22, 'Ciencias y Tecnología 1°',    'CIE-1', 3),
(23, 'Lenguaje 1°',                 'LEN-1', 3),
(24, 'Estudios Sociales 1°',       'SOC-1', 3),
(25, 'Idioma Extranjero Inglés 1°','ING-1', 3),

-- 5° Grado
(6,  'Matemáticas 5°',             'MAT-5', 7),
(7,  'Ciencias Naturales 5°',      'CIE-5', 7),
(8,  'Lenguaje y Literatura 5°',   'LEN-5', 7),
(9,  'Estudios Sociales 5°',       'SOC-5', 7),
(10, 'Idioma Extranjero Inglés 5°','ING-5', 7),

-- 9° Grado
(26, 'Matemáticas 9°',             'MAT-9', 11),
(27, 'Ciencias Naturales 9°',      'CIE-9', 11),
(28, 'Lenguaje y Literatura 9°',   'LEN-9', 11),
(29, 'Estudios Sociales 9°',       'SOC-9', 11),
(30, 'Idioma Extranjero Inglés 9°','ING-9', 11);

SELECT setval('materias_id_materia_seq', 30);
