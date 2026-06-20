-- Asistencias (4 semanas de febrero 2026)
DO $$
    DECLARE
        rec RECORD;
        v_fecha DATE;
        v_tipo VARCHAR(15);
        v_obs TEXT;
        v_asistencia_id INT := 1;
    BEGIN
        FOR rec IN 
            SELECT ia.id_inscripcion, ia.id_matricula, h.dia_semana 
            FROM inscripciones_asignaturas ia
            JOIN asignaciones_docentes ad ON ad.id_asignacion_docente = ia.id_asignacion_docente
            JOIN horarios h ON h.id_asignacion_docente = ad.id_asignacion_docente
            ORDER BY ia.id_inscripcion
        LOOP
            -- Genera 4 registros de asistencia (uno por semana en febrero 2026)
            FOR week IN 1..4 LOOP
                v_fecha := CASE week
                    WHEN 1 THEN DATE '2026-02-01' + rec.dia_semana
                    WHEN 2 THEN DATE '2026-02-08' + rec.dia_semana
                    WHEN 3 THEN DATE '2026-02-15' + rec.dia_semana
                    WHEN 4 THEN DATE '2026-02-22' + rec.dia_semana
                END;
                
                v_tipo := 'presente';
                v_obs := NULL;
                
                -- Ausencias específicas para disparar alertas o reflejar registros reales
                IF rec.id_matricula % 8 = 3 AND rec.dia_semana = 1 AND week IN (2, 3) THEN
                    v_tipo := 'ausente';
                    v_obs := 'Inasistencia sin justificar';
                ELSIF rec.id_matricula % 8 = 5 AND rec.dia_semana = 2 AND week = 2 THEN
                    v_tipo := 'ausente';
                    v_obs := 'Cita médica';
                ELSIF rec.id_matricula % 8 = 6 AND rec.dia_semana = 3 AND week = 1 THEN
                    v_tipo := 'ausente';
                    v_obs := 'Problemas de transporte';
                END IF;
                
                INSERT INTO asistencias (id_asistencia, id_inscripcion, fecha, tipo_asistencia, observacion)
                VALUES (v_asistencia_id, rec.id_inscripcion, v_fecha, v_tipo, v_obs);
                
                v_asistencia_id := v_asistencia_id + 1;
            END LOOP;
        END LOOP;
    END;
$$;

SELECT setval('asistencias_id_asistencia_seq', (SELECT MAX(id_asistencia) FROM asistencias));
