{{ config(materialized='view') }}

select
    *,
    exp(sum(ln(1 + daily_return)) over (partition by ticker order by date)) - 1 as cum_return
from {{ ref('i_returns') }}
