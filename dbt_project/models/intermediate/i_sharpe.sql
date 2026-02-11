{{ config(materialized='view') }}

with base as (
    select
        `date`,
        ticker,
        daily_return,
        daily_return - (0.04 / 252) as excess_return
    from {{ ref('i_returns') }}
)

select
    `date`,
    ticker,

    safe_multiply(
        safe_divide(
            avg(excess_return) over (
                partition by ticker
                order by `date`
                rows between 29 preceding and current row
            ),
            nullif(
                stddev_samp(excess_return) over (
                    partition by ticker
                    order by `date`
                    rows between 29 preceding and current row
                ),
                0
            )
        ),
        sqrt(252)
    ) as sharpe_ratio

from base
order by ticker, `date`

