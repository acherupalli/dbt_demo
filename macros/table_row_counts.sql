{% macro table_row_counts(schema_name) %}
    {% set tables_query = "SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA = '" ~ schema_name ~ "'" %}
    {% set tables = run_query(tables_query) %}
    
    {# Loop through each table to generate SQL for counting rows #}
    {% set counts_sql = [] %}
    {% for table in tables %}
        {% set table_name = table.TABLE_NAME %}
        {% set count_sql = "SELECT '" ~ table_name ~ "' AS table_name, COUNT(*) AS row_count FROM " ~ schema_name ~ "." ~ table_name %}
        {% do counts_sql.append(count_sql) %}
    {% endfor %}
    
    {# Combine all SQL statements into a single string #}
    {% set counts_sql_str = counts_sql|join("\nUNION ALL\n") %}
    
    {# Wrap the SQL in a CTE and return the result #}
    WITH table_row_counts AS (
        {{ counts_sql_str }}
    )
    SELECT * FROM table_row_counts
{% endmacro %}