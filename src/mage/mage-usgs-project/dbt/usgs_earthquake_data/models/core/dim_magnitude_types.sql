-- Load data from magnitude_codes.csv seed file
{{ config(materialized='table') }}

-- Create dimension table
SELECT * FROM {{ ref('magnitude_types') }}