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
    event_key 
    , client_key
    , page_key
    , user_id 
    , event_name 
    , event_date_dt 
    , event_timestamp
    , page_path 
    , page_location
    , page_referrer 
    , original_page_location
    , original_page_referrer
    , device_category 
    , device_web_info_browser 
    , geo_country 
    , geo_region
    , geo_city 
    , geo_metro
from {{ref('stg_ga4__events')}}
{% if is_incremental() %}
    where event_date_dt in ({{ partitions_to_replace | join(',') }})
{% endif %}