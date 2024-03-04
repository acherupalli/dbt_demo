{% macro generate_comparison_test1(schema1, schema1_table1, schema2, schema2_table1, test_id, test_description) %}
    SELECT {{ test_id }} AS test_id,
           '{{ test_description }}' AS test_description,
           CURRENT_DATE() AS test_date,
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL - ' || COUNT(*) END AS test_result
    FROM (
            SELECT CLAIM_ID, OMD_INSERT_DATETIME
            FROM {{ schema1 }}.{{ schema1_table1 }}
            EXCEPT
            SELECT CLAIM_ID, OMD_INSERT_DATETIME
            FROM {{ schema2 }}.{{ schema2_table1 }}
        )
{% endmacro %}

{% macro generate_comparison_test2(schema1, schema1_table2, schema2, schema2_table2, test_id, test_description) %}    
    SELECT {{ test_id }} AS test_id,
           '{{ test_description }}' AS test_description,
           CURRENT_DATE() AS test_date,
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL - ' || COUNT(*) END AS test_result
    FROM (
            SELECT CLAIM_PAYMT_ID, OMD_INSERT_DATETIME
            FROM {{ schema1 }}.{{ schema1_table2 }}
            EXCEPT
            SELECT CLAIM_PAYMT_ID, OMD_INSERT_DATETIME
            FROM {{ schema2 }}.{{ schema2_table2 }}
        )
{% endmacro %}

{% macro hstg_int_sync(schema1, schema2, schema1_table1, schema2_table1, schema1_table2, schema2_table2) %}
    WITH hstg_int_sync AS (
        {{ generate_comparison_test1(schema1, schema1_table1, schema2, schema2_table1, 1, 'CLAIM HSTG to INT check to ensure that all CLAIM_IDs present in HSTG are in INT') }}
        UNION ALL
        {{ generate_comparison_test2(schema1, schema1_table2, schema2, schema2_table2, 2, 'CLAIM PAYMENT HSTG to INT check to ensure that all CLAIM_PAYMT_IDs present in HSTG are in INT') }}
    )
SELECT * FROM hstg_int_sync
{% endmacro %}