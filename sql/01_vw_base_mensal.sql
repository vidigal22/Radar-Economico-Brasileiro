-- Criar a view no BigQuery
CREATE OR REPLACE VIEW `radar-economia-br.economia_br.vw_base_mensal` AS
WITH ipca AS (
  SELECT
    DATE_TRUNC(data, MONTH) AS mes,
    valor AS ipca_mensal,
    IF(
      COUNT(valor) OVER w = 12,
      (EXP(SUM(LN(1 + valor / 100)) OVER w) - 1) * 100,
      NULL
    ) AS ipca_12m
  FROM `radar-economia-br.economia_br.raw_ipca_mensal`
  WINDOW w AS (ORDER BY data ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)
),

selic AS (
  SELECT
    DATE_TRUNC(data, MONTH) AS mes,
    AVG(valor) AS selic_media
  FROM `radar-economia-br.economia_br.raw_selic_meta`
  GROUP BY mes
),

dolar AS (
  SELECT
    DATE_TRUNC(data, MONTH) AS mes,
    AVG(valor) AS dolar_medio,
    ARRAY_AGG(valor ORDER BY data DESC LIMIT 1)[OFFSET(0)] AS dolar_fim_mes
  FROM `radar-economia-br.economia_br.raw_dolar_venda`
  GROUP BY mes
),

desemprego AS (
  SELECT DATE_TRUNC(data, MONTH) AS mes, valor AS desemprego
  FROM `radar-economia-br.economia_br.raw_desemprego`
),

ibc AS (
  SELECT DATE_TRUNC(data, MONTH) AS mes, valor AS ibc_br
  FROM `radar-economia-br.economia_br.raw_ibc_br`
),

base AS (
  SELECT
    i.mes,
    i.ipca_mensal,
    i.ipca_12m,
    s.selic_media,
    d.dolar_medio,
    d.dolar_fim_mes,
    e.desemprego,
    b.ibc_br
  FROM ipca i
  LEFT JOIN selic s USING (mes)
  LEFT JOIN dolar d USING (mes)
  LEFT JOIN desemprego e USING (mes)
  LEFT JOIN ibc b USING (mes)
)

SELECT
  *,
  ROUND((dolar_medio / LAG(dolar_medio) OVER (ORDER BY mes) - 1) * 100, 2) AS dolar_var_pct,
  ROUND((ibc_br / LAG(ibc_br, 12) OVER (ORDER BY mes) - 1) * 100, 2) AS ibc_br_var_12m,
  ROUND(((1 + selic_media / 100) / (1 + ipca_12m / 100) - 1) * 100, 2) AS juro_real
FROM base
ORDER BY mes;


-- Conferir o resultado
SELECT *
FROM `SEU_PROJETO_ID.economia_br.vw_base_mensal`
ORDER BY mes DESC
LIMIT 24;