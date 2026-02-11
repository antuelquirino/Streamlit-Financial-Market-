{{ config(materialized='table') }}

-- 1. Source and Intermediate Model References
with p as (
    select 
        `date`, 
        ticker, 
        close as price
    from {{ ref('stg_prices') }}
),

r as (
    select 
        `date`, 
        ticker, 
        daily_return
    from {{ ref('i_returns') }}
),

c as (
    select 
        `date`, 
        ticker, 
        cum_return
    from {{ ref('i_cumulative') }}
),

v as (
    select 
        `date`, 
        ticker, 
        volatility
    from {{ ref('i_volatility') }}
),

d as (
    select 
        `date`, 
        ticker, 
        drawdown
    from {{ ref('i_drawdown') }}
),

s as (
    select 
        `date`, 
        ticker, 
        sharpe_ratio
    from {{ ref('i_sharpe') }}
),

cagr as (
    select 
        ticker, 
        cagr
    from {{ ref('i_cagr') }}
),

meta as (
    select 
        ticker, 
        company_name, 
        sector, 
        industry
    from {{ ref('stg_metadata') }}
)

-- 2. Final metrics consolidation and entity enrichment
select
    p.`date`,
    p.ticker,
    meta.company_name,
    meta.sector,
    meta.industry,
    p.price,
    r.daily_return,
    c.cum_return,
    v.volatility,
    d.drawdown,
    s.sharpe_ratio,
    cagr.cagr
from p
left join r    on p.`date` = r.`date` and p.ticker = r.ticker
left join c    on p.`date` = c.`date` and p.ticker = c.ticker
left join v    on p.`date` = v.`date` and p.ticker = v.ticker
left join d    on p.`date` = d.`date` and p.ticker = d.ticker
left join s    on p.`date` = s.`date` and p.ticker = s.ticker
left join cagr on p.ticker = cagr.ticker
left join meta on p.ticker = meta.ticker
order by p.ticker, p.`date`
