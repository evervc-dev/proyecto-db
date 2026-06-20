-- Evaluaciones (5 evaluaciones por asignatura en total)
DO $$
    DECLARE
        rec RECORD;
        v_eval_id INT := 1;
    BEGIN
        FOR rec IN SELECT id_asignacion_docente FROM asignaciones_docentes ORDER BY id_asignacion_docente LOOP
            -- Trimestre 1 (Suma = 100%)
            INSERT INTO evaluaciones (id_evaluacion, id_asignacion_docente, trimestre, nombre, tipo, peso_porcentual, fecha_evaluacion)
            VALUES 
            (v_eval_id,     rec.id_asignacion_docente, 1, 'Examen Trimestre 1', 'examen', 40.00, '2026-03-10'),
            (v_eval_id + 1, rec.id_asignacion_docente, 1, 'Laboratorio 1',      'laboratorio', 30.00, '2026-02-15'),
            (v_eval_id + 2, rec.id_asignacion_docente, 1, 'Tareas del Cuaderno', 'cuaderno', 30.00, '2026-03-25');
            
            -- Trimestre 2 (Suma = 100%)
            INSERT INTO evaluaciones (id_evaluacion, id_asignacion_docente, trimestre, nombre, tipo, peso_porcentual, fecha_evaluacion)
            VALUES
            (v_eval_id + 3, rec.id_asignacion_docente, 2, 'Examen Trimestre 2', 'examen', 50.00, '2026-06-15'),
            (v_eval_id + 4, rec.id_asignacion_docente, 2, 'Proyecto del Trimestre', 'proyecto', 50.00, '2026-06-01');
            
            v_eval_id := v_eval_id + 5;
        END LOOP;
    END;
$$;

SELECT setval('evaluaciones_id_evaluacion_seq', (SELECT MAX(id_evaluacion) FROM evaluaciones));
