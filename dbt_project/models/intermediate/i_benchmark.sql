{{ config(materialized='view') }}

with stock as (
    select
        `date`,
        ticker,
        cum_return/100.0 as stock_cum_return
    from {{ ref('i_cumulative') }}
    where ticker != 'SP500' 
),

benchmark as (
    select
        `date`,
        cum_return/100.0 as benchmark_cum_return
    from {{ ref('i_cumulative') }}
    where ticker = 'SP500'
)

select
    s.`date`, 
    s.ticker,
    s.stock_cum_return,
    b.benchmark_cum_return,
    (s.stock_cum_return - coalesce(b.benchmark_cum_return, 0)) as excess_return
from stock s
left join benchmark b on s.`date` = b.`date`



