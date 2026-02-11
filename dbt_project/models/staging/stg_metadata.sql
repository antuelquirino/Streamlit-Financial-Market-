{{ config(
    materialized='view'
) }}

-- Staging table for company metadata
-- Cleans column names and prepares data for intermediate/marts layer

select
    ticker,
    company_name,
    sector,
    industry,
    market_cap
from
    raw_finance.company_metadata

