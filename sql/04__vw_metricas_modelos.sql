-- Métricas dos modelos (valores do notebook 05; atualizar se retreinar)
CREATE OR REPLACE VIEW `radar-economia-br.economia_br.vw_metricas_modelos` AS
SELECT 'Random Forest' AS modelo, 0.285 AS mae_todo_periodo, 0.216 AS mae_sem_covid
UNION ALL SELECT 'Ridge', 0.289, 0.217
UNION ALL SELECT 'Baseline: média 12 meses', 0.304, 0.230
UNION ALL SELECT 'Baseline: mês anterior', 0.323, 0.273
UNION ALL SELECT 'Baseline: mesmo mês do ano anterior', 0.394, 0.280;