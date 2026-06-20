-- Personal docente
INSERT INTO personal (id_personal, dui, nombres, apellidos, correo, telefono, especialidad, activo) VALUES
-- Matemáticas
(1,  '01010101-1', 'Alejandra', 'Alvarez',   'alejandra.alvarez@escuela.edu.sv',   '2200-0001', 'Matemáticas', TRUE),
(2,  '02020202-2', 'Andres',    'Benitez',   'andres.benitez@escuela.edu.sv',       '2200-0002', 'Matemáticas', TRUE),
(3,  '03030303-3', 'Carmen',    'Blanco',    'carmen.blanco@escuela.edu.sv',        '2200-0003', 'Matemáticas', TRUE),
(4,  '04040404-4', 'Daniel',    'Bravo',     'daniel.bravo@escuela.edu.sv',         '2200-0004', 'Matemáticas', TRUE),
-- Ciencias Naturales
(5,  '05050505-5', 'Elena',     'Cabrera',   'elena.cabrera@escuela.edu.sv',        '2200-0005', 'Ciencias Naturales', TRUE),
(6,  '06060606-6', 'Fernando',  'Calvo',     'fernando.calvo@escuela.edu.sv',       '2200-0006', 'Ciencias Naturales', TRUE),
(7,  '07070707-7', 'Gloria',    'Castro',    'gloria.castro@escuela.edu.sv',        '2200-0007', 'Ciencias Naturales', TRUE),
(8,  '08080808-8', 'Hector',    'Diaz',      'hector.diaz@escuela.edu.sv',          '2200-0008', 'Ciencias Naturales', TRUE),
-- Lenguaje y Literatura
(9,  '09090909-9', 'Irene',     'Fernandez', 'irene.fernandez@escuela.edu.sv',      '2200-0009', 'Lenguaje y Literatura', TRUE),
(10, '10101010-0', 'Jaime',     'Gomez',     'jaime.gomez@escuela.edu.sv',          '2200-0010', 'Lenguaje y Literatura', TRUE),
(11, '11111111-1', 'Laura',     'Gonzalez',  'laura.gonzalez@escuela.edu.sv',       '2200-0011', 'Lenguaje y Literatura', TRUE),
(12, '12121212-2', 'Mario',     'Gutierrez', 'mario.gutierrez@escuela.edu.sv',      '2200-0012', 'Lenguaje y Literatura', TRUE),
-- Estudios Sociales
(13, '13131313-3', 'Patricia',  'Hernandez', 'patricia.hernandez@escuela.edu.sv',  '2200-0013', 'Estudios Sociales', TRUE),
(14, '14141414-4', 'Roberto',   'Herrera',   'roberto.herrera@escuela.edu.sv',      '2200-0014', 'Estudios Sociales', TRUE),
(15, '15151515-5', 'Silvia',    'Jimenez',   'silvia.jimenez@escuela.edu.sv',       '2200-0015', 'Estudios Sociales', TRUE),
(16, '16161616-6', 'Tomas',     'Lopez',     'tomas.lopez@escuela.edu.sv',          '2200-0016', 'Estudios Sociales', TRUE),
-- Idioma Extranjero Inglés
(17, '17171717-7', 'Victoria',  'Martinez',  'victoria.martinez@escuela.edu.sv',    '2200-0017', 'Idioma Extranjero Inglés', TRUE),
(18, '18181818-8', 'Aaron',     'Morales',   'aaron.morales@escuela.edu.sv',        '2200-0018', 'Idioma Extranjero Inglés', TRUE),
(19, '19191919-9', 'Belen',     'Moreno',    'belen.moreno@escuela.edu.sv',         '2200-0019', 'Idioma Extranjero Inglés', TRUE),
(20, '20202020-0', 'Carlos',    'Perez',     'carlos.perez@escuela.edu.sv',         '2200-0020', 'Idioma Extranjero Inglés', TRUE);

SELECT setval('personal_id_personal_seq', 20);
