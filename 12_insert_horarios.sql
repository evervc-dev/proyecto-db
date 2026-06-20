-- Horarios de prueba
INSERT INTO horarios (id_horario, id_asignacion_docente, dia_semana, hora_inicio, hora_fin, aula) VALUES
-- 1° Grado A (id_seccion = 1, Turno Mañana) - Aula 1A
(1,  1,  1, '07:00:00', '08:30:00', 'Aula 1A'), -- Lunes MAT-1
(2,  2,  2, '07:00:00', '08:30:00', 'Aula 1A'), -- Martes CIE-1
(3,  3,  3, '07:00:00', '08:30:00', 'Aula 1A'), -- Miércoles LEN-1
(4,  4,  4, '07:00:00', '08:30:00', 'Aula 1A'), -- Jueves SOC-1
(5,  5,  5, '07:00:00', '08:30:00', 'Aula 1A'), -- Viernes ING-1

-- 1° Grado B (id_seccion = 2, Turno Tarde) - Aula 1B
(6,  6,  1, '13:00:00', '14:30:00', 'Aula 1B'), -- Lunes MAT-1
(7,  7,  2, '13:00:00', '14:30:00', 'Aula 1B'), -- Martes CIE-1
(8,  8,  3, '13:00:00', '14:30:00', 'Aula 1B'), -- Miércoles LEN-1
(9,  9,  4, '13:00:00', '14:30:00', 'Aula 1B'), -- Jueves SOC-1
(10, 10, 5, '13:00:00', '14:30:00', 'Aula 1B'), -- Viernes ING-1

-- 5° Grado A (id_seccion = 9, Turno Mañana) - Aula 5A
(11, 11, 1, '08:30:00', '10:00:00', 'Aula 5A'), -- Lunes MAT-5
(12, 12, 2, '08:30:00', '10:00:00', 'Aula 5A'), -- Martes CIE-5
(13, 13, 3, '08:30:00', '10:00:00', 'Aula 5A'), -- Miércoles LEN-5
(14, 14, 4, '08:30:00', '10:00:00', 'Aula 5A'), -- Jueves SOC-5
(15, 15, 5, '08:30:00', '10:00:00', 'Aula 5A'), -- Viernes ING-5

-- 5° Grado B (id_seccion = 10, Turno Tarde) - Aula 5B
(16, 16, 1, '14:30:00', '16:00:00', 'Aula 5B'), -- Lunes MAT-5
(17, 17, 2, '14:30:00', '16:00:00', 'Aula 5B'), -- Martes CIE-5
(18, 18, 3, '14:30:00', '16:00:00', 'Aula 5B'), -- Miércoles LEN-5
(19, 19, 4, '14:30:00', '16:00:00', 'Aula 5B'), -- Jueves SOC-5
(20, 20, 5, '14:30:00', '16:00:00', 'Aula 5B'), -- Viernes ING-5

-- 9° Grado A (id_seccion = 15, Turno Completo) - Aula 9A
(21, 21, 1, '10:00:00', '11:30:00', 'Aula 9A'), -- Lunes MAT-9
(22, 22, 2, '10:00:00', '11:30:00', 'Aula 9A'), -- Martes CIE-9
(23, 23, 3, '10:00:00', '11:30:00', 'Aula 9A'), -- Miércoles LEN-9
(24, 24, 4, '10:00:00', '11:30:00', 'Aula 9A'), -- Jueves SOC-9
(25, 25, 5, '10:00:00', '11:30:00', 'Aula 9A'), -- Viernes ING-9

-- 9° Grado B (id_seccion = 16, Turno Completo) - Aula 9B
(26, 26, 1, '11:30:00', '13:00:00', 'Aula 9B'), -- Lunes MAT-9
(27, 27, 2, '11:30:00', '13:00:00', 'Aula 9B'), -- Martes CIE-9
(28, 28, 3, '11:30:00', '13:00:00', 'Aula 9B'), -- Miércoles LEN-9
(29, 29, 4, '11:30:00', '13:00:00', 'Aula 9B'), -- Jueves SOC-9
(30, 30, 5, '11:30:00', '13:00:00', 'Aula 9B'); -- Viernes ING-9

SELECT setval('horarios_id_horario_seq', 30);
