{{ config(materialized='view') }}

with base as (
    select
        ticker,
        min(date) as start_date,
        max(date) as end_date,
        max(cum_return) as final_cum_return
    from {{ ref('i_cumulative') }}
    group by ticker
)

select
    ticker,
    final_cum_return,
    start_date,
    end_date,
    -- CAGR = (1 + total_return)^(1/years) - 1
    pow(1 + final_cum_return, 365 / date_diff(end_date, start_date, day)) - 1 as cagr
from base
