SELECT
  p.category,
  ROUND(SUM(oi.sale_price), 2) AS receita,
  ROUND(SUM(oi.sale_price - p.cost), 2) AS lucro,
  ROUND(SAFE_DIVIDE(SUM(oi.sale_price - p.cost), SUM(oi.sale_price)) * 100, 1) AS margem_pct
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p ON oi.product_id = p.id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY p.category
ORDER BY lucro DESC;