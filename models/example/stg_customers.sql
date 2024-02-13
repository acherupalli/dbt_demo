with stg_customers AS (
    SELECT
       customer_id,
       CONCAT(firstname,' ', lastname) as customer_name,
       email as email_address,
       address as billing_address
    FROM raw.customer
)

select * from stg_customers
