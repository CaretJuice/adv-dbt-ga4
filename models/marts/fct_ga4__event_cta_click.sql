{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}
{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'insert_overwrite',
        tags = ["incremental"],
        partition_by={
            "field": "event_date_dt",
            "data_type": "date",
            "granularity": "day"
        },
        partitions = partitions_to_replace
    )
}}
select
    {{ build_event_model('cta_click') }}
from {{ref('stg_ga4__event_cta_click')}}
{% if is_incremental() %}
    where event_date_dt in ({{ partitions_to_replace | join(',') }})
{% endif %}