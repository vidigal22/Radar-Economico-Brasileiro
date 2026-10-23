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
