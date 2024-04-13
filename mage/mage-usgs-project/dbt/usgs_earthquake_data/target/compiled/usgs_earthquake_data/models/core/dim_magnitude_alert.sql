

select 
    staging_data.event_magnitude as mag,
    case 
        when staging_data.event_magnitude < 2.0 then 'Micro'
        when staging_data.event_magnitude >= 2.0 and staging_data.event_magnitude < 3.0 then 'Minor'
        when staging_data.event_magnitude >= 3.0 and staging_data.event_magnitude < 4.0 then 'Slight'
        when staging_data.event_magnitude >= 4.0 and staging_data.event_magnitude < 5.0 then 'Light'
        when staging_data.event_magnitude >= 5.0 and staging_data.event_magnitude < 6.0 then 'Moderate'
        when staging_data.event_magnitude >= 6.0 and staging_data.event_magnitude < 7.0 then 'Strong'
        when staging_data.event_magnitude >= 7.0 and staging_data.event_magnitude < 8.0 then 'Major'
        when staging_data.event_magnitude >= 8.0 and staging_data.event_magnitude < 9.0 then 'Great'
        when staging_data.event_magnitude >= 9.0 and staging_data.event_magnitude <= 10.0 then 'Extreme'
        else 'Unknown'
    end as magnitude_alert_level
from `usgs-earthquake-data`.`usgs_earthquake_data`.`staging_usgs_earthquake_data` as staging_data