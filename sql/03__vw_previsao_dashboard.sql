-- Une as previsões do período de teste e a previsão futura (usada no Looker Studio)
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