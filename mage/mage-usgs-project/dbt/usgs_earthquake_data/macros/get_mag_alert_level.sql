{% macro get_mag_alert_level(mag_value) %}
    CASE 
        WHEN {{ mag_value }} < 0 THEN 'Unknown'
        WHEN {{ mag_value }} >= 0 AND {{ mag_value }} < 2 THEN 'Micro'
        WHEN {{ mag_value }} >= 2 AND {{ mag_value }} < 3 THEN 'Minor'
        WHEN {{ mag_value }} >= 3 AND {{ mag_value }} < 4 THEN 'Slight'
        WHEN {{ mag_value }} >= 4 AND {{ mag_value }} < 5 THEN 'Light'
        WHEN {{ mag_value }} >= 5 AND {{ mag_value }} < 6 THEN 'Moderate'
        WHEN {{ mag_value }} >= 6 AND {{ mag_value }} < 7 THEN 'Strong'
        WHEN {{ mag_value }} >= 7 AND {{ mag_value }} < 8 THEN 'Major'
        WHEN {{ mag_value }} >= 8 AND {{ mag_value }} < 9 THEN 'Great'
        WHEN {{ mag_value }} >= 9 THEN 'Extreme'
        ELSE 'Unknown'
    END
{% endmacro %}