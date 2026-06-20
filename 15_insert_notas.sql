-- Notas (calificaciones para evaluaciones de T1 y T2)
DO $$
    DECLARE
        rec RECORD;
        v_nota1 NUMERIC(4,2);
        v_nota2 NUMERIC(4,2);
        v_nota3 NUMERIC(4,2);
        v_nota4 NUMERIC(4,2);
        v_nota5 NUMERIC(4,2);
        v_nota_id INT := 1;
    BEGIN
        FOR rec IN 
            SELECT id_inscripcion, id_matricula, id_asignacion_docente 
            FROM inscripciones_asignaturas 
            ORDER BY id_inscripcion
        LOOP
            -- Distribución del rendimiento estudiantil
            CASE rec.id_matricula % 8
                WHEN 0 THEN
                    v_nota1 := 9.50; v_nota2 := 10.00; v_nota3 := 9.00; v_nota4 := 9.50; v_nota5 := 10.00;
                WHEN 1 THEN
                    v_nota1 := 8.50; v_nota2 := 8.00;  v_nota3 := 9.00; v_nota4 := 8.50; v_nota5 := 9.00;
                WHEN 2 THEN
                    v_nota1 := 7.50; v_nota2 := 7.00;  v_nota3 := 8.00; v_nota4 := 7.50; v_nota5 := 8.00;
                WHEN 3 THEN
                    v_nota1 := 6.50; v_nota2 := 7.00;  v_nota3 := 6.80; v_nota4 := 7.20; v_nota5 := 6.50;
                WHEN 4 THEN
                    v_nota1 := 6.00; v_nota2 := 6.50;  v_nota3 := 6.00; v_nota4 := 6.00; v_nota5 := 6.50;
                WHEN 5 THEN
                    v_nota1 := 5.00; v_nota2 := 5.50;  v_nota3 := 4.50; v_nota4 := 5.50; v_nota5 := 5.00;
                WHEN 6 THEN
                    v_nota1 := 4.50; v_nota2 := 5.00;  v_nota3 := 5.50; v_nota4 := 7.50; v_nota5 := 8.00;
                WHEN 7 THEN
                    v_nota1 := 8.00; v_nota2 := 8.50;  v_nota3 := 7.50; v_nota4 := 8.00; v_nota5 := 8.50;
            END CASE;
            
            -- Inserta las notas para las 5 evaluaciones correspondientes a esta clase
            INSERT INTO notas (id_nota, id_inscripcion, id_evaluacion, nota) VALUES
            (v_nota_id,     rec.id_inscripcion, 5 * (rec.id_asignacion_docente - 1) + 1, v_nota1),
            (v_nota_id + 1, rec.id_inscripcion, 5 * (rec.id_asignacion_docente - 1) + 2, v_nota2),
            (v_nota_id + 2, rec.id_inscripcion, 5 * (rec.id_asignacion_docente - 1) + 3, v_nota3),
            (v_nota_id + 3, rec.id_inscripcion, 5 * (rec.id_asignacion_docente - 1) + 4, v_nota4),
            (v_nota_id + 4, rec.id_inscripcion, 5 * (rec.id_asignacion_docente - 1) + 5, v_nota5);
            
            v_nota_id := v_nota_id + 5;
        END LOOP;
    END;
$$;

SELECT setval('notas_id_nota_seq', (SELECT MAX(id_nota) FROM notas));
