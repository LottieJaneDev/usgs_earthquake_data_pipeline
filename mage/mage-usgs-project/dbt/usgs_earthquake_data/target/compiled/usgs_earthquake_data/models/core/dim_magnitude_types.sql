

select 
    magType, 
    case 
        when magType = 'Me' then 'Energy'
        when magType in ('Mi', 'Mwp') then 'Integrated p-wave'
        when magType in ('Mw', 'mw', 'mww', 'Mww') then 'W-phase'
        when magType in ('Mwc', 'mwb', 'Mwb') then 'Body Wave'
        when magType in ('Mwr', 'mwr') then 'Regional'
        when magType = 'Ms' then 'Surface Wave'
        when magType in ('mb', 'mb_Lg', 'mb_lg') then 'Short Period Body Wave'
        when magType in ('ML', 'Ml', 'ml') then 'Local'
        when magType in ('Md', 'md') then 'Duration'
        when magType = 'Mh' then 'Other / Temporary Designation'
        when magType = 'Mint' then 'Intensity'
        when magType = 'FFM' then 'Finite Fault Modeling'
        when magType = 'Mfa' then 'Felt Area'
        else 'Unknown' 
    end as magnitude_conversion_type
from `usgs-earthquake-data`.`usgs_earthquake_data`.`magnitude_types`