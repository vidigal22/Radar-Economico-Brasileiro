SELECT
  DATE_TRUNC(DATE(created_at), MONTH) AS mes,
  COUNT(DISTINCT order_id) AS pedidos,
  ROUND(SUM(sale_price), 2) AS receita
FROM `bigquery-public-data.thelook_ecommerce.order_items`
WHERE status NOT IN ('Cancelled', 'Returned')
GROUP BY mes
ORDER BY mes;