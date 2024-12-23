{% set partitions_to_replace = ['current_date'] %}
{% for i in range(var('static_incremental_days')) %}
    {% set partitions_to_replace = partitions_to_replace.append('date_sub(current_date, interval ' + (i+1)|string + ' day)') %}
{% endfor %}

{{config(
    materialized = 'incremental',
    unique_key=['date']
)}}
with evnt as (
    select  
        event_date_dt as date 
        , device_category 
        , sum(case 
            when event_name = 'session_start' then 1 
            else 0
        end) as session_start_count
        , sum(case 
            when event_name = 'view_item' then 1 
            else 0 
        end) as view_item_count
        , sum(case 
            when event_name = 'add_to_cart' then 1 
            else 0 
        end) as add_to_cart_count
        , sum(case 
            when event_name = 'begin_checkout' then 1 
            else 0 
        end) as begin_checkout_count
        , sum(case 
            when event_name = 'add_shipping_info' then 1 
            else 0 
        end) as add_shipping_info_count
        , sum(case 
            when event_name = 'add_payment_info' then 1 
            else 0 
        end) as add_payment_info_count
        , sum(case 
            when event_name = 'purchase' then 1 
            else 0 
        end) as purchase_count    
      from {{ref('fct_ga4__events')}}
    {% if is_incremental() %}
        where event_date_dt in ({{ partitions_to_replace | join(', ') }})
    {% endif %}
    group by 1,2
)

select 
    *
from evnt 
