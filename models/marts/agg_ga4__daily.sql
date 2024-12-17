{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}

{{config(
    materialized = 'incremental',
    unique_key=['date']
)}}

select 
    session_partition_date as date 
    , sum(session_partition_count_page_views) as page_views 
    , sum(session_partition_sum_engagement_time_msec) as engagement_time_msec 
    , sum(session_partition_max_session_engaged) as engaged_sessions 
    , count(session_partition_key) as sessions 
    , countif(session_number = 1) as new_sessions 
    , countif(session_number > 1) as returning_sessions 
    , countif(session_partition_count_page_views = 1) as one_page_view_sessions
    , count(distinct user_id) as daily_users
    , sum(purchase_count) as purchases
from {{ref('fct_ga4__sessions_daily')}}
{% if is_incremental() %}
    where session_partition_date in ({{ partitions_to_replace | join(', ') }})
{% endif %}
group by 1