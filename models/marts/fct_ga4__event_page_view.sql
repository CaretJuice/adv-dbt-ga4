

select
    {{ build_event_model('page_view') }}
from {{ref('stg_ga4__event_page_view')}}