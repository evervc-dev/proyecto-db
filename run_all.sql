-- Ejecución general de scripts de base de datos
\echo 'Iniciando instalación del sistema...'

\echo 'Recreando la base de datos...'
DROP DATABASE IF EXISTS sistema_escolar;
CREATE DATABASE sistema_escolar;

\echo 'Conectando a la nueva base de datos...'
\c sistema_escolar

\echo 'Instalando tablas y restricciones...'
\i 01_schema.sql

\echo 'Instalando vistas analíticas...'
\i 02_views.sql

\echo 'Instalando procedimientos y triggers...'
\i 03_procedures_triggers.sql

\echo 'Cargando años lectivos...'
\i 04_insert_anos_lectivos.sql

\echo 'Cargando grados...'
\i 05_insert_grados.sql

\echo 'Cargando secciones...'
\i 06_insert_secciones.sql

\echo 'Cargando docentes...'
\i 07_insert_personal.sql

\echo 'Cargando materias...'
\i 08_insert_materias.sql

\echo 'Cargando estudiantes...'
\i 09_insert_estudiantes.sql

\echo 'Cargando matrículas...'
\i 10_insert_matriculas.sql

\echo 'Cargando asignaciones docentes...'
\i 11_insert_asignaciones_docentes.sql

\echo 'Cargando horarios...'
\i 12_insert_horarios.sql

\echo 'Cargando inscripciones a asignaturas...'
\i 13_insert_inscripciones_asignaturas.sql

\echo 'Cargando evaluaciones...'
\i 14_insert_evaluaciones.sql

\echo 'Cargando notas...'
\i 15_insert_notas.sql

\echo 'Cargando asistencias...'
\i 16_insert_asistencias.sql

\echo 'Cargando alertas académicas...'
\i 17_insert_alertas_academicas.sql

\echo 'Instalación finalizada con éxito.'
