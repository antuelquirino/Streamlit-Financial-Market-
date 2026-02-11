{{ config(materialized='view') }}

select
    `date`,
    ticker,

    stddev_samp(daily_return) over (
        partition by ticker
        order by `date`
        rows between 251 preceding and current row
    ) * sqrt(252) as volatility

from {{ ref('i_returns') }}
order by ticker, `date`



