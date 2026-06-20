# Guía de Datos de Prueba (Semilla 2026)

Esta guía documenta la estructura y el contenido de los datos de prueba cargados en el sistema escolar para el año lectivo 2026. Ha sido diseñada con datos 100% coherentes y funcionales para facilitar pruebas de triggers, reportes y lógica escolar.

> [!NOTE]
> Todos los datos pertenecen al año lectivo activo **2026** (ID: `5`). Las secciones A y B de 1°, 5° y 9° grados están completamente pobladas con estudiantes, horarios, notas de 2 trimestres y asistencias.

---

## Volumen de Registros

La base de datos cuenta con la siguiente cantidad de registros detallados para pruebas de carga y rendimiento:

| Tabla | Registros | Descripción de los datos |
| :--- | :---: | :--- |
| `anos_lectivos` | 5 | Años del 2022 al 2026 (2026 activo). |
| `grados` | 11 | Niveles educativos de Parvularia a 9° Grado. |
| `secciones` | 6 | Secciones A y B para 1° Grado, 5° Grado y 9° Grado. |
| `personal` | 20 | Catálogo completo de 20 docentes clasificados por especialidad. |
| `materias` | 15 | 5 asignaturas fundamentales para los 3 grados poblados. |
| `estudiantes` | 48 | 8 estudiantes distribuidos por sección. |
| `matriculas` | 48 | Matrículas activas (tipo nueva, reingreso, traslado). |
| `asignaciones_docentes` | 30 | Vinculación del docente con su asignatura y sección (5 materias × 6 secciones). |
| `horarios` | 30 | Horarios semanales únicos de 1.5 horas (sin choques de docente, aula ni sección). |
| `inscripciones_asignaturas` | 240 | Inscripción de cada estudiante a las 5 materias correspondientes a su sección. |
| `evaluaciones` | 150 | 5 evaluaciones por materia (3 en Trimestre 1 y 2 en Trimestre 2). |
| `notas` | 1200 | Calificaciones desglosadas en T1 y T2 para todos los estudiantes. |
| `asistencias` | 960 | 4 semanas de registro de asistencia de febrero de 2026. |
| `alertas_academicas` | 4 resueltas + *activas* | Alertas del sistema (bajo promedio e inasistencias) generadas automáticamente. |

---

## Distribución de Grados, Secciones y Horarios

A continuación se detalla la planificación horaria y de docentes asignados para cada grado y sección. Las clases se imparte una vez por semana de Lunes a Viernes.

### 1. Primer Grado (id_grado: 3)
*   **Materias**: Matemáticas 1° (`MAT-1`), Ciencias y Tecnología 1° (`CIE-1`), Lenguaje 1° (`LEN-1`), Estudios Sociales 1° (`SOC-1`), Inglés 1° (`ING-1`).

| Sección | Aula | Turno | Día / Hora | Materia | Docente |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **A** (ID: 1) | Aula 1A | Mañana | Lun 07:00 - 08:30 | Matemáticas 1° | Alejandra Alvarez (ID: 1) |
| **A** (ID: 1) | Aula 1A | Mañana | Mar 07:00 - 08:30 | Ciencias y Tec. 1° | Elena Cabrera (ID: 5) |
| **A** (ID: 1) | Aula 1A | Mañana | Mié 07:00 - 08:30 | Lenguaje 1° | Irene Fernandez (ID: 9) |
| **A** (ID: 1) | Aula 1A | Mañana | Jue 07:00 - 08:30 | Estudios Soc. 1° | Patricia Hernandez (ID: 13) |
| **A** (ID: 1) | Aula 1A | Mañana | Vie 07:00 - 08:30 | Inglés 1° | Victoria Martinez (ID: 17) |
| **B** (ID: 2) | Aula 1B | Tarde | Lun 13:00 - 14:30 | Matemáticas 1° | Alejandra Alvarez (ID: 1) |
| **B** (ID: 2) | Aula 1B | Tarde | Mar 13:00 - 14:30 | Ciencias y Tec. 1° | Elena Cabrera (ID: 5) |
| **B** (ID: 2) | Aula 1B | Tarde | Mié 13:00 - 14:30 | Lenguaje 1° | Irene Fernandez (ID: 9) |
| **B** (ID: 2) | Aula 1B | Tarde | Jue 13:00 - 14:30 | Estudios Soc. 1° | Patricia Hernandez (ID: 13) |
| **B** (ID: 2) | Aula 1B | Tarde | Vie 13:00 - 14:30 | Inglés 1° | Victoria Martinez (ID: 17) |

### 2. Quinto Grado (id_grado: 7)
*   **Materias**: Matemáticas 5° (`MAT-5`), Ciencias Naturales 5° (`CIE-5`), Lenguaje y Literatura 5° (`LEN-5`), Estudios Sociales 5° (`SOC-5`), Inglés 5° (`ING-5`).

| Sección | Aula | Turno | Día / Hora | Materia | Docente |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **A** (ID: 9) | Aula 5A | Mañana | Lun 08:30 - 10:00 | Matemáticas 5° | Andres Benitez (ID: 2) |
| **A** (ID: 9) | Aula 5A | Mañana | Mar 08:30 - 10:00 | Ciencias Nat. 5° | Fernando Calvo (ID: 6) |
| **A** (ID: 9) | Aula 5A | Mañana | Mié 08:30 - 10:00 | Lenguaje y Lit. 5° | Jaime Gomez (ID: 10) |
| **A** (ID: 9) | Aula 5A | Mañana | Jue 08:30 - 10:00 | Estudios Soc. 5° | Roberto Herrera (ID: 14) |
| **A** (ID: 9) | Aula 5A | Mañana | Vie 08:30 - 10:00 | Inglés 5° | Aaron Morales (ID: 18) |
| **B** (ID: 10) | Aula 5B | Tarde | Lun 14:30 - 16:00 | Matemáticas 5° | Andres Benitez (ID: 2) |
| **B** (ID: 10) | Aula 5B | Tarde | Mar 14:30 - 16:00 | Ciencias Nat. 5° | Fernando Calvo (ID: 6) |
| **B** (ID: 10) | Aula 5B | Tarde | Mié 14:30 - 16:00 | Lenguaje y Lit. 5° | Jaime Gomez (ID: 10) |
| **B** (ID: 10) | Aula 5B | Tarde | Jue 14:30 - 16:00 | Estudios Soc. 5° | Roberto Herrera (ID: 14) |
| **B** (ID: 10) | Aula 5B | Tarde | Vie 14:30 - 16:00 | Inglés 5° | Aaron Morales (ID: 18) |

### 3. Noveno Grado (id_grado: 11)
*   **Materias**: Matemáticas 9° (`MAT-9`), Ciencias Naturales 9° (`CIE-9`), Lenguaje y Literatura 9° (`LEN-9`), Estudios Sociales 9° (`SOC-9`), Inglés 9° (`ING-9`).

| Sección | Aula | Turno | Día / Hora | Materia | Docente |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **A** (ID: 15) | Aula 9A | Completo | Lun 10:00 - 11:30 | Matemáticas 9° | Carmen Blanco (ID: 3) |
| **A** (ID: 15) | Aula 9A | Completo | Mar 10:00 - 11:30 | Ciencias Nat. 9° | Gloria Castro (ID: 7) |
| **A** (ID: 15) | Aula 9A | Completo | Mié 10:00 - 11:30 | Lenguaje y Lit. 9° | Laura Gonzalez (ID: 11) |
| **A** (ID: 15) | Aula 9A | Completo | Jue 10:00 - 11:30 | Estudios Soc. 9° | Silvia Jimenez (ID: 15) |
| **A** (ID: 15) | Aula 9A | Completo | Vie 10:00 - 11:30 | Inglés 9° | Belen Moreno (ID: 19) |
| **B** (ID: 16) | Aula 9B | Completo | Lun 11:30 - 13:00 | Matemáticas 9° | Carmen Blanco (ID: 3) |
| **B** (ID: 16) | Aula 9B | Completo | Mar 11:30 - 13:00 | Ciencias Nat. 9° | Gloria Castro (ID: 7) |
| **B** (ID: 16) | Aula 9B | Completo | Mié 11:30 - 13:00 | Lenguaje y Lit. 9° | Laura Gonzalez (ID: 11) |
| **B** (ID: 16) | Aula 9B | Completo | Jue 11:30 - 13:00 | Estudios Soc. 9° | Silvia Jimenez (ID: 15) |
| **B** (ID: 16) | Aula 9B | Completo | Vie 11:30 - 13:00 | Inglés 9° | Belen Moreno (ID: 19) |

---

## Perfiles Académicos de los Estudiantes (Pruebas de Alertas)

Las notas y asistencias de los estudiantes siguen un patrón según su identificador único de matrícula (`id_matricula % 8`). Esto permite probar de forma directa las alertas académicas autogeneradas por los triggers:

### Rendimiento Académico Crítico
Los estudiantes cuyo `id_matricula % 8 = 5` presentan un promedio reprobatorio en el primer y segundo trimestre (promedio < 6.00). Esto genera una alerta activa automática de tipo `promedio_bajo`.
*   **Estudiantes afectados**:
    *   **1° Grado A**: Aaron Morales (Matrícula ID: `5`)
    *   **1° Grado B**: Diego Delgado (Matrícula ID: `13`)
    *   **5° Grado A**: Ernesto Gil (Matrícula ID: `21`)
    *   **5° Grado B**: Luis Lozano (Matrícula ID: `29`)
    *   **9° Grado A**: Alberto Alvarez (Matrícula ID: `37`)
    *   **9° Grado B**: Mario Gutierrez (Matrícula ID: `45`)

### Rendimiento Académico Temporal (T1)
Los estudiantes cuyo `id_matricula % 8 = 6` reprueban en el Trimestre 1 (promedio < 6.00), activando la alerta. No obstante, en el Trimestre 2 se recuperan con un promedio sobresaliente.
*   **Estudiantes afectados**:
    *   **1° Grado A**: Andres Benitez (Matrícula ID: `6`)
    *   **1° Grado B**: Edgar Flores (Matrícula ID: `14`)
    *   **5° Grado A**: Gabriel Gomez (Matrícula ID: `22`)
    *   **5° Grado B**: Nicolas Marin (Matrícula ID: `30`)
    *   **9° Grado A**: Daniel Bravo (Matrícula ID: `38`)
    *   **9° Grado B**: Ramon Reyes (Matrícula ID: `46`)

### Inasistencia Excesiva
Los estudiantes cuyo `id_matricula % 8 = 3` tienen registradas dos inasistencias en la materia de **Matemáticas** (Lunes) durante febrero. Esto equivale al 50% de inasistencias (límite máximo permitido: 25%), lo que dispara la alerta `inasistencia_excesiva`.
*   **Estudiantes afectados**:
    *   **1° Grado A**: Amelia Arias (Matrícula ID: `3`)
    *   **1° Grado B**: Celia Cambil (Matrícula ID: `11`)
    *   **5° Grado A**: Irene Fernandez (Matrícula ID: `19`)
    *   **5° Grado B**: Victoria Martinez (Matrícula ID: `27`)
    *   **9° Grado A**: Ines Iglesias (Matrícula ID: `35`)
    *   **9° Grado B**: Paula Parra (Matrícula ID: `43`)

### Estudiantes de Alto Desempeño
Los estudiantes cuyo `id_matricula % 8 = 0` obtienen calificaciones perfectas (entre 9.00 y 10.00) en todas las evaluaciones.
*   **Estudiantes**: David Crespo (Matrícula ID: `8`), Emilio Garcia (Matrícula ID: `16`), Jorge Leon (Matrícula ID: `24`), Tomas Lopez (Matrícula ID: `32`), Hector Diaz (Matrícula ID: `40`), Samuel Sanz (Matrícula ID: `48`).

---

## Archivos Fuente del Proyecto

Los scripts SQL modificados se encuentran en las siguientes rutas relativas para referencia:

*   **Esquema de Base de Datos**: [01_schema.sql](01_schema.sql)
*   **Vistas Analíticas**: [02_views.sql](02_views.sql)
*   **Funciones, Triggers y Procedimientos**: [03_procedures_triggers.sql](03_procedures_triggers.sql)
*   **Secciones Semilla**: [06_insert_secciones.sql](06_insert_secciones.sql)
*   **Materias Semilla**: [08_insert_materias.sql](08_insert_materias.sql)
*   **Estudiantes Semilla**: [09_insert_estudiantes.sql](09_insert_estudiantes.sql)
*   **Matrículas Semilla**: [10_insert_matriculas.sql](10_insert_matriculas.sql)
*   **Asignaciones Docentes**: [11_insert_asignaciones_docentes.sql](11_insert_asignaciones_docentes.sql)
*   **Horarios Semilla**: [12_insert_horarios.sql](12_insert_horarios.sql)
*   **Inscripciones Semilla**: [13_insert_inscripciones_asignaturas.sql](13_insert_inscripciones_asignaturas.sql)
*   **Evaluaciones Semilla**: [14_insert_evaluaciones.sql](14_insert_evaluaciones.sql)
*   **Notas Semilla**: [15_insert_notas.sql](15_insert_notas.sql)
*   **Asistencias Semilla**: [16_insert_asistencias.sql](16_insert_asistencias.sql)
*   **Alertas Semilla**: [17_insert_alertas_academicas.sql](17_insert_alertas_academicas.sql)
