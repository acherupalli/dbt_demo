SELECT
       customer_id,
       CONCAT(firstname,' ', lastname) as customer_name,
       email as email_address,
       address as billing_address
    FROM raw.customer