{% macro get_mag_type_conversion_name(magType) %}
    CASE 
        WHEN {{ magType }} = 'Me' THEN 'Energy'
        WHEN {{ magType }} IN ('Mi', 'Mwp') THEN 'Integrated p-wave'
        WHEN {{ magType }} IN ('Mw', 'mw', 'mww', 'Mww') THEN 'W-phase'
        WHEN {{ magType }} IN ('Mwc', 'mwb', 'Mwb') THEN 'Body Wave'
        WHEN {{ magType }} IN ('Mwr', 'mwr') THEN 'Regional'
        WHEN {{ magType }} = 'Ms' THEN 'Surface Wave'
        WHEN {{ magType }} IN ('mb', 'mb_Lg', 'mb_lg') THEN 'Short Period Body Wave'
        WHEN {{ magType }} IN ('ML', 'Ml', 'ml') THEN 'Local'
        WHEN {{ magType }} IN ('Md', 'md') THEN 'Duration'
        WHEN {{ magType }} = 'Mh' THEN 'Other / Temporary Designation'
        WHEN {{ magType }} = 'Mint' THEN 'Intensity'
        WHEN {{ magType }} = 'FFM' THEN 'Finite Fault Modeling'
        WHEN {{ magType }} = 'Mfa' THEN 'Felt Area'
        ELSE 'Unknown' 
    END
{% endmacro %}
