{% macro limit_rows(source_table, target_table, row_limit) %}
  create or replace table {{ target_table }} as
  select * from {{ source_table }} limit {{ row_limit }};
{% endmacro %}