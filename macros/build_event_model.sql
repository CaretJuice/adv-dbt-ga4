{% macro build_event_model( event_name ) %}
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
    {% if var("default_custom_parameters", none) != none %}
        {{ ga4.stage_custom_parameters( var("default_custom_paramters", none ) ) }}
    {% endif %}
    {% if var( event_name+"_custom_parameters", none) != none %}
        {{ ga4.stage_custom_parameters( var(event_name+"_custom_parameters", none ) ) }}
    {% endif %}
    {% if event_name in ('purchase') %}
        , total_item_quantity
        , purchase_revenue_in_usd
        , purchase_revenue 
        , tax_value_in_usd 
        , tax_value 
        , unique_items 
        , transaction_id  
    {% endif %}

{% endmacro %}