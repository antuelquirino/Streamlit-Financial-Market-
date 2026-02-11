{{ config(materialized='view') }}

select
    `date`,
    ticker,
    close,
    lag(close) over (partition by ticker order by `date`) as prev_close,
    close / lag(close) over (partition by ticker order by `date`) - 1 as daily_return
from {{ ref('stg_prices') }}
