{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}

{{config(
    materialized = 'incremental',
    unique_key=['date']
)}}
with ses as (
    select
        session_partition_key 
        , session_default_channel_grouping as channel 
    from {{ref('dim_ga4__sessions_daily')}}
    {% if is_incremental() %}
        where session_partition_date in ({{ partitions_to_replace | join(', ') }})
    {% endif %}
)
, evnt as (
    select 
        session_partition_key 
        , event_date_dt as date 
        , device_category
        , event_name 
        , count(*) as event_count
    from {{ref('fct_ga4__events')}}
    where event_name in ('session_start', 'view_item', 'add_to_cart', 'begin_checkout', 'add_shipping_info', 'add_payment_info' , 'purchase')
    {% if is_incremental() %}
        and event_date_dt in ({{ partitions_to_replace | join(', ') }})
    {% endif %}
    group by 1,2,3,4
)

select 
    evnt.date 
    , evnt.device_category 
    , ses.channel 
    , max(case 
        when evnt.event_name = 'session_start' then evnt.event_count 
        else null 
      end) as session_start_count
    , max(case 
        when evnt.event_name = 'view_item' then evnt.event_count 
        else null 
      end) as view_item_count
    , max(case 
        when evnt.event_name = 'add_to_cart' then evnt.event_count 
        else null 
      end) as add_to_cart_count
    , max(case 
        when evnt.event_name = 'begin_checkout' then evnt.event_count 
        else null 
      end) as begin_checkout_count
    , max(case 
        when evnt.event_name = 'add_shipping_info' then evnt.event_count 
        else null 
      end) as add_shipping_info_count
    , max(case 
        when evnt.event_name = 'add_payment_info' then evnt.event_count 
        else null 
      end) as add_payment_info_count
    , max(case 
        when evnt.event_name = 'purchase' then evnt.event_count 
        else null 
      end) as purchase_count
from ses 
left join evnt using(session_partition_key)
group by 1,2,3