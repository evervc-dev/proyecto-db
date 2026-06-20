-- Asignaciones de docentes a las 5 materias básicas para las 2 secciones y 3 grados
INSERT INTO asignaciones_docentes (id_asignacion_docente, id_personal, id_materia, id_seccion, id_ano_lectivo) VALUES
-- 1° Grado A (id_seccion = 1)
(1,  1,  21, 1,  5), -- Alejandra Alvarez - Matemáticas 1°
(2,  5,  22, 1,  5), -- Elena Cabrera - Ciencias y Tecnología 1°
(3,  9,  23, 1,  5), -- Irene Fernandez - Lenguaje 1°
(4,  13, 24, 1,  5), -- Patricia Hernandez - Estudios Sociales 1°
(5,  17, 25, 1,  5), -- Victoria Martinez - Idioma Extranjero Inglés 1°

-- 1° Grado B (id_seccion = 2)
(6,  1,  21, 2,  5), -- Alejandra Alvarez - Matemáticas 1°
(7,  5,  22, 2,  5), -- Elena Cabrera - Ciencias y Tecnología 1°
(8,  9,  23, 2,  5), -- Irene Fernandez - Lenguaje 1°
(9,  13, 24, 2,  5), -- Patricia Hernandez - Estudios Sociales 1°
(10, 17, 25, 2,  5), -- Victoria Martinez - Idioma Extranjero Inglés 1°

-- 5° Grado A (id_seccion = 9)
(11, 2,  6,  9,  5), -- Andres Benitez - Matemáticas 5°
(12, 6,  7,  9,  5), -- Fernando Calvo - Ciencias Naturales 5°
(13, 10, 8,  9,  5), -- Jaime Gomez - Lenguaje y Literatura 5°
(14, 14, 9,  9,  5), -- Roberto Herrera - Estudios Sociales 5°
(15, 18, 10, 9,  5), -- Aaron Morales - Idioma Extranjero Inglés 5°

-- 5° Grado B (id_seccion = 10)
(16, 2,  6,  10, 5), -- Andres Benitez - Matemáticas 5°
(17, 6,  7,  10, 5), -- Fernando Calvo - Ciencias Naturales 5°
(18, 10, 8,  10, 5), -- Jaime Gomez - Lenguaje y Literatura 5°
(19, 14, 9,  10, 5), -- Roberto Herrera - Estudios Sociales 5°
(20, 18, 10, 10, 5), -- Aaron Morales - Idioma Extranjero Inglés 5°

-- 9° Grado A (id_seccion = 15)
(21, 3,  26, 15, 5), -- Carmen Blanco - Matemáticas 9°
(22, 7,  27, 15, 5), -- Gloria Castro - Ciencias Naturales 9°
(23, 11, 28, 15, 5), -- Laura Gonzalez - Lenguaje y Literatura 9°
(24, 15, 29, 15, 5), -- Silvia Jimenez - Estudios Sociales 9°
(25, 19, 30, 15, 5), -- Belen Moreno - Idioma Extranjero Inglés 9°

-- 9° Grado B (id_seccion = 16)
(26, 3,  26, 16, 5), -- Carmen Blanco - Matemáticas 9°
(27, 7,  27, 16, 5), -- Gloria Castro - Ciencias Naturales 9°
(28, 11, 28, 16, 5), -- Laura Gonzalez - Lenguaje y Literatura 9°
(29, 15, 29, 16, 5), -- Silvia Jimenez - Estudios Sociales 9°
(30, 19, 30, 16, 5); -- Belen Moreno - Idioma Extranjero Inglés 9°

SELECT setval('asignaciones_docentes_id_asignacion_docente_seq', 30);
