-- View 1: previsto vs. real
CREATE OR REPLACE VIEW `radar-economia-br.economia_br.vw_previsao_dashboard` AS
SELECT
  DATE(mes) AS mes,
  real,
  Random_Forest AS previsto_rf,
  Ridge AS previsto_ridge,
  Baseline_media_12_meses AS baseline_media_12m,
  'Teste (walk-forward)' AS tipo,
  CAST(NULL AS FLOAT64) AS limite_inferior_90,
  CAST(NULL AS FLOAT64) AS limite_superior_90
FROM `radar-economia-br.economia_br.previsoes_ipca_teste`

UNION ALL

SELECT
  DATE(mes_alvo) AS mes,
  CAST(NULL AS FLOAT64) AS real,
  previsao AS previsto_rf,
  CAST(NULL AS FLOAT64) AS previsto_ridge,
  CAST(NULL AS FLOAT64) AS baseline_media_12m,
  'Previsão futura' AS tipo,
  limite_inferior_90,
  limite_superior_90
FROM `radar-economia-br.economia_br.previsoes_ipca_futuro`;


-- View 2: métricas dos modelos
CREATE OR REPLACE VIEW `radar-economia-br.economia_br.vw_metricas_modelos` AS
SELECT 'Random Forest' AS modelo, 0.285 AS mae_todo_periodo, 0.216 AS mae_sem_covid
UNION ALL SELECT 'Ridge', 0.289, 0.217
UNION ALL SELECT 'Baseline: média 12 meses', 0.304, 0.230
UNION ALL SELECT 'Baseline: mês anterior', 0.323, 0.273
UNION ALL SELECT 'Baseline: mesmo mês do ano anterior', 0.394, 0.280;