{{ config(materialized='view') }}

with cum_returns as (
    select
        `date`,
        ticker,
        cum_return
    from {{ ref('i_cumulative') }}
),

max_cum as (
    select
        `date`,
        ticker,
        cum_return,
        max(cum_return) over (
            partition by ticker
            order by `date`
            rows between unbounded preceding and current row
        ) as running_max
    from cum_returns
)

select
    `date`,
    ticker,
    cum_return,
    running_max,
    safe_divide(cum_return - running_max, running_max) as drawdown
from max_cum
order by ticker, `date`


