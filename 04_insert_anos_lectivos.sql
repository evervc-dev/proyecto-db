-- Datos prueba en años lectivos
INSERT INTO anos_lectivos (id_ano_lectivo, anio, activo, fecha_inicio, fecha_fin) VALUES
(1, 2022, FALSE, '2022-01-15', '2022-11-15'),
(2, 2023, FALSE, '2023-01-15', '2023-11-15'),
(3, 2024, FALSE, '2024-01-15', '2024-11-15'),
(4, 2025, FALSE, '2025-01-15', '2025-11-15'),
(5, 2026, TRUE,  '2026-01-15', '2026-11-15'); -- Año lectivo actual (activo)

SELECT setval('anos_lectivos_id_ano_lectivo_seq', 5);
