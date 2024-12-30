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
            "field": "date",
            "data_type": "date",
            "granularity": "day"
        },
        partitions = partitions_to_replace
    )
}}

with pv as (
    select 
        event_date_dt as date 
        , stream_id
        , page_location  -- includes query string parameters not listed in query_parameter_exclusions variable
        , page_key
        , count(event_name) as page_views
        , count(distinct client_key ) as distinct_client_keys
        , sum( if(session_number = 1,1,0)) as new_client_keys
        , sum(entrances) as entrances
        , count(distinct 
            case 
                when session_number = 1 and user_id is not null then user_id 
                when session_number = 1 then client_key
                else null 
            end 
        ) as new_users
        , count(distinct 
            case 
                when session_number > 1 and user_id is not null then user_id 
                when session_number > 1 then client_key else null 
            end 
        ) as returning_users
    from {{ref('fct_ga4__event_page_view')}}
    {% if is_incremental() %}
            where event_date_dt in ({{ partitions_to_replace | join(',') }})
    {% endif %}
    group by 1,2,3,4
)

select * from pv 
