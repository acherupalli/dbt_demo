SELECT
   c.customer_id,
   c.customer_name,
   o.address,
   o.date
FROM
    raw.orders o
JOIN
    {{ ref("stg_customers") }} c ON o.ID = c.customer_id
