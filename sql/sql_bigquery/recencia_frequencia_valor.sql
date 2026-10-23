-- RFM (Recência, Frequência, Valor) com window functions
CREATE OR REPLACE VIEW `SEU_PROJETO.analise_ecommerce.vw_rfm` AS
WITH base AS (
  SELECT
    user_id,
    DATE_DIFF(DATE '2024-01-01', MAX(DATE(created_at)), DAY) AS recencia,
    COUNT(DISTINCT order_id) AS frequencia,
    ROUND(SUM(sale_price), 2) AS valor
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY user_id
)
SELECT
  *,
  NTILE(5) OVER (ORDER BY recencia DESC) AS r_score,
  NTILE(5) OVER (ORDER BY frequencia)    AS f_score,
  NTILE(5) OVER (ORDER BY valor)         AS v_score
FROM base;

-- Retenção por coorte
WITH primeira AS (
  SELECT user_id, DATE_TRUNC(MIN(DATE(created_at)), MONTH) AS coorte
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  GROUP BY user_id
),
atividade AS (
  SELECT DISTINCT user_id, DATE_TRUNC(DATE(created_at), MONTH) AS mes_ativo
  FROM `bigquery-public-data.thelook_ecommerce.orders`
)
SELECT
  p.coorte,
  DATE_DIFF(a.mes_ativo, p.coorte, MONTH) AS meses_desde_inicio,
  COUNT(DISTINCT a.user_id) AS clientes_ativos
FROM primeira p
JOIN atividade a USING (user_id)
GROUP BY coorte, meses_desde_inicio
ORDER BY coorte, meses_desde_inicio;