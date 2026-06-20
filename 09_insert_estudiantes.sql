-- 48 estudiantes para 4 secciones (1° A, 1° B, 5° A, 5° B, 9° A, 9° B)
INSERT INTO estudiantes (id_estudiante, nie, nombres, apellidos, fecha_nacimiento, genero, es_repitente, tiene_extraedad, pertenece_dai, actividad_economica, convivencia, activo) VALUES
-- 1° Grado A (id_seccion = 1)
(1,  'NIE00001', 'Adela',    'Aguilar',   '2019-04-12', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(2,  'NIE00002', 'Alba',     'Alonso',    '2019-08-22', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(3,  'NIE00003', 'Amelia',   'Arias',     '2019-11-05', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(4,  'NIE00004', 'Beatriz',  'Blanco',    '2019-01-30', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(5,  'NIE00005', 'Aaron',    'Morales',   '2019-05-15', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con el padre', TRUE),
(6,  'NIE00006', 'Andres',   'Benitez',   '2019-03-25', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(7,  'NIE00007', 'Carlos',   'Perez',     '2019-09-14', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(8,  'NIE00008', 'David',    'Crespo',    '2019-07-19', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),

-- 1° Grado B (id_seccion = 2)
(9,  'NIE00009', 'Belen',    'Bravo',     '2019-06-12', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(10, 'NIE00010', 'Carmen',   'Caballero', '2019-10-22', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(11, 'NIE00011', 'Celia',    'Cambil',    '2019-02-05', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(12, 'NIE00012', 'Claudia',  'Carrasco',  '2019-12-30', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(13, 'NIE00013', 'Diego',    'Delgado',   '2019-04-15', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(14, 'NIE00014', 'Edgar',    'Flores',    '2019-08-25', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(15, 'NIE00015', 'Eliseo',   'Fuentes',   '2019-11-14', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(16, 'NIE00016', 'Emilio',   'Garcia',    '2019-01-19', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),

-- 5° Grado A (id_seccion = 9)
(17, 'NIE00017', 'Elena',    'Cabrera',   '2015-04-12', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(18, 'NIE00018', 'Gloria',   'Castro',    '2015-08-22', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(19, 'NIE00019', 'Irene',    'Fernandez', '2015-11-05', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(20, 'NIE00020', 'Laura',    'Gonzalez',  '2015-01-30', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(21, 'NIE00021', 'Ernesto',  'Gil',       '2015-05-15', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con el padre', TRUE),
(22, 'NIE00022', 'Gabriel',  'Gomez',     '2015-03-25', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(23, 'NIE00023', 'Jaime',    'Gomez',     '2015-09-14', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(24, 'NIE00024', 'Jorge',    'Leon',      '2015-07-19', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),

-- 5° Grado B (id_seccion = 10)
(25, 'NIE00025', 'Patricia', 'Hernandez', '2015-06-12', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(26, 'NIE00026', 'Silvia',   'Jimenez',   '2015-10-22', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(27, 'NIE00027', 'Victoria', 'Martinez',  '2015-02-05', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(28, 'NIE00028', 'Natalia',  'Medina',    '2015-12-30', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(29, 'NIE00029', 'Luis',     'Lozano',    '2015-04-15', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(30, 'NIE00030', 'Nicolas',  'Marin',     '2015-08-25', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(31, 'NIE00031', 'Roberto',  'Herrera',   '2015-11-14', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(32, 'NIE00032', 'Tomas',    'Lopez',     '2015-01-19', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),

-- 9° Grado A (id_seccion = 15)
(33, 'NIE00033', 'Carolina', 'Calvo',     '2011-04-12', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(34, 'NIE00034', 'Fabiola',  'Ferrer',    '2011-08-22', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(35, 'NIE00035', 'Ines',     'Iglesias',  '2011-11-05', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(36, 'NIE00036', 'Lorena',   'Lopez',     '2011-01-30', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(37, 'NIE00037', 'Alberto',  'Alvarez',   '2011-05-15', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con el padre', TRUE),
(38, 'NIE00038', 'Daniel',   'Bravo',     '2011-03-25', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(39, 'NIE00039', 'Fernando', 'Calvo',     '2011-09-14', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(40, 'NIE00040', 'Hector',   'Diaz',      '2011-07-19', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),

-- 9° Grado B (id_seccion = 16)
(41, 'NIE00041', 'Maria',    'Martin',    '2011-06-12', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(42, 'NIE00042', 'Olga',     'Ortega',    '2011-10-22', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(43, 'NIE00043', 'Paula',    'Parra',     '2011-02-05', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(44, 'NIE00044', 'Rosa',     'Reyes',     '2011-12-30', 'F', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(45, 'NIE00045', 'Mario',    'Gutierrez', '2011-04-15', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(46, 'NIE00046', 'Ramon',    'Reyes',     '2011-08-25', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE),
(47, 'NIE00047', 'Ruben',    'Ruiz',      '2011-11-14', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con ambos', TRUE),
(48, 'NIE00048', 'Samuel',   'Sanz',      '2011-01-19', 'M', FALSE, FALSE, FALSE, 'No trabaja', 'Vive con la madre', TRUE);

SELECT setval('estudiantes_id_estudiante_seq', 48);
