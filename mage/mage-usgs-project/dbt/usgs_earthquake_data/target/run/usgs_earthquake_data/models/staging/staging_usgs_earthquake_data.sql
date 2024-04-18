

  create or replace view `usgs-earthquake-data`.`usgs_earthquake_data`.`staging_usgs_earthquake_data`
  OPTIONS()
  as 

with
    source_data_partitioned as (
        select *, row_number() over (partition by id, time order by updated desc) as rn
        from `usgs-earthquake-data`.`usgs_earthquake_data`.`usgs_earthquake_data_raw_2024`
        where time is not null
    ),
    source_data as (
        select
            *,
            cast(time as timestamp) as time_timestamp,
            cast(time as date) as event_date,
            cast(time as time) as event_time
        from source_data_partitioned
    )
select
    -- identifiers
    to_hex(md5(cast(coalesce(cast(id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(time as string), '_dbt_utils_surrogate_key_null_') as string))) as unique_event_id,
    
    safe_cast(id as string)
 as event_id,
    
    safe_cast(time_timestamp as timestamp)
 as event_datetime,
    
    safe_cast(updated as timestamp)
 as last_updated,
    
    safe_cast(event_date as date)
 as event_date,
    
    safe_cast(event_time as time)
 as event_time,
    
    safe_cast(date_partition as date)
 as date_partition,
    coalesce(cast(mag_cluster as string), 'Unknown') as mag_cluster_partition,
    -- location
    
    safe_cast(latitude as Float64)
 as event_latitude,
    
    safe_cast(longitude as Float64)
 as event_longitude,
    coalesce(cast(place as string), 'Unknown') as descriptive_geographic_region,
    -- seismic data
    coalesce(cast(type as string), 'Unknown') as event_type,
    cast(mag as numeric) as event_magnitude,
    
    CASE 
        WHEN mag < 0 THEN 'Unknown'
        WHEN mag >= 0 AND mag < 2 THEN 'Micro'
        WHEN mag >= 2 AND mag < 3 THEN 'Minor'
        WHEN mag >= 3 AND mag < 4 THEN 'Slight'
        WHEN mag >= 4 AND mag < 5 THEN 'Light'
        WHEN mag >= 5 AND mag < 6 THEN 'Moderate'
        WHEN mag >= 6 AND mag < 7 THEN 'Strong'
        WHEN mag >= 7 AND mag < 8 THEN 'Major'
        WHEN mag >= 8 AND mag < 9 THEN 'Great'
        WHEN mag >= 9 THEN 'Extreme'
        ELSE 'Unknown'
    END
 as magnitude_alert_level,
    cast(depth as numeric) as depth_km,
    coalesce(cast(magtype as string), 'Unknown') as magnitude_conversion_type_id,
    
    CASE 
        WHEN magtype = 'Me' THEN 'Energy'
        WHEN magtype IN ('Mi', 'Mwp') THEN 'Integrated p-wave'
        WHEN magtype IN ('Mw', 'mw', 'mww', 'Mww') THEN 'W-phase'
        WHEN magtype IN ('Mwc', 'mwb', 'Mwb') THEN 'Body Wave'
        WHEN magtype IN ('Mwr', 'mwr') THEN 'Regional'
        WHEN magtype = 'Ms' THEN 'Surface Wave'
        WHEN magtype IN ('mb', 'mb_Lg', 'mb_lg') THEN 'Short Period Body Wave'
        WHEN magtype IN ('ML', 'Ml', 'ml') THEN 'Local'
        WHEN magtype IN ('Md', 'md') THEN 'Duration'
        WHEN magtype = 'Mh' THEN 'Other / Temporary Designation'
        WHEN magtype = 'Mint' THEN 'Intensity'
        WHEN magtype = 'FFM' THEN 'Finite Fault Modeling'
        WHEN magtype = 'Mfa' THEN 'Felt Area'
        ELSE 'Unknown' 
    END
 as magnitude_conversion_type_name,
    cast(nst as numeric) as no_stations_to_calculate_location,
    cast(gap as decimal) as largest_gap_between_stations,
    cast(dmin as decimal) as dist_epicenter_to_station_degrees,
    cast(rms as decimal) as root_mean_square_residual_seconds,
    cast(horizontalerror as decimal) as horizontal_location_error_km,
    cast(deptherror as decimal) as depth_uncertainty_km,
    cast(magerror as decimal) as magnitude_uncertainty,
    cast(magnst as numeric) as no_stations_to_calculate_magnitude,
    -- network id/name data
    coalesce(cast(status as string), 'Unknown') as event_review_status,
    coalesce(cast(net as string), 'Unknown') as data_contributor_network_id,
    
    case
        when net = 'ak' then 'Alaska Geophysical Network (AK)'
        when net = 'at' then 'National Tsunami Warning Center Alaska Seismic Network (AT)'
        when net = 'av' then 'Alaska Volcano Observatory (AV)'
        when net = 'ci' then 'Southern California Seismic Network (SCSN) (CI)'
        when net = 'hv' then 'Hawaiian Volcano Observatory Network (HV)'
        when net = 'mb' then 'Montana Regional Seismic Network (MB)'
        when net = 'nc' then 'USGS Northern California Seismic Network (NC)'
        when net = 'nn' then 'Nevada Seismic Network (NN)'
        when net = 'nm' then 'Cooperative New Madrid Seismic Network (NM)'
        when net = 'ok' then 'Oklahoma Seismic Network (OK)'
        when net = 'pgc' then 'Unknown'
        when net = 'pr' then 'Puerto Rico Seismic Network & Puerto Rico Strong Motion Program (PR)'
        when net = 'se' then 'Southeastern Appalachian Cooperative Seismic Network (SE)'
        when net = 'tx' then 'Texas Seismological Network (TX)'
        when net = 'uu' then 'University of Utah Regional Seismic Network (UU)'
        when net = 'us' then 'United States National Seismic Network (US)'
        when net = 'uw' then 'Pacific Northwest Seismic Network - University of Washington (UW)'
        when net = 'zamg' then 'Zentralanstalt für Meterologie und Geodynamik (ZAMG)'
        else 'Unknown'
    end
 as data_contributor_network_name,
    coalesce(cast(locationsource as string), 'Unknown') as network_reported_by_id,
    
    case
        when locationsource = 'ak' then 'Alaska Geophysical Network (AK)'
        when locationsource = 'at' then 'National Tsunami Warning Center Alaska Seismic Network (AT)'
        when locationsource = 'av' then 'Alaska Volcano Observatory (AV)'
        when locationsource = 'ci' then 'Southern California Seismic Network (SCSN) (CI)'
        when locationsource = 'hv' then 'Hawaiian Volcano Observatory Network (HV)'
        when locationsource = 'mb' then 'Montana Regional Seismic Network (MB)'
        when locationsource = 'nc' then 'USGS Northern California Seismic Network (NC)'
        when locationsource = 'nn' then 'Nevada Seismic Network (NN)'
        when locationsource = 'nm' then 'Cooperative New Madrid Seismic Network (NM)'
        when locationsource = 'ok' then 'Oklahoma Seismic Network (OK)'
        when locationsource = 'pgc' then 'Unknown'
        when locationsource = 'pr' then 'Puerto Rico Seismic Network & Puerto Rico Strong Motion Program (PR)'
        when locationsource = 'se' then 'Southeastern Appalachian Cooperative Seismic Network (SE)'
        when locationsource = 'tx' then 'Texas Seismological Network (TX)'
        when locationsource = 'uu' then 'University of Utah Regional Seismic Network (UU)'
        when locationsource = 'us' then 'United States National Seismic Network (US)'
        when locationsource = 'uw' then 'Pacific Northwest Seismic Network - University of Washington (UW)'
        when locationsource = 'zamg' then 'Zentralanstalt für Meterologie und Geodynamik (ZAMG)'
        else 'Unknown'
    end
 as network_reported_by_name,
    coalesce(cast(magsource as string), 'Unknown') as network_magnitude_author_id,
    
    case
        when magsource = 'ak' then 'Alaska Geophysical Network (AK)'
        when magsource = 'at' then 'National Tsunami Warning Center Alaska Seismic Network (AT)'
        when magsource = 'av' then 'Alaska Volcano Observatory (AV)'
        when magsource = 'ci' then 'Southern California Seismic Network (SCSN) (CI)'
        when magsource = 'hv' then 'Hawaiian Volcano Observatory Network (HV)'
        when magsource = 'mb' then 'Montana Regional Seismic Network (MB)'
        when magsource = 'nc' then 'USGS Northern California Seismic Network (NC)'
        when magsource = 'nn' then 'Nevada Seismic Network (NN)'
        when magsource = 'nm' then 'Cooperative New Madrid Seismic Network (NM)'
        when magsource = 'ok' then 'Oklahoma Seismic Network (OK)'
        when magsource = 'pgc' then 'Unknown'
        when magsource = 'pr' then 'Puerto Rico Seismic Network & Puerto Rico Strong Motion Program (PR)'
        when magsource = 'se' then 'Southeastern Appalachian Cooperative Seismic Network (SE)'
        when magsource = 'tx' then 'Texas Seismological Network (TX)'
        when magsource = 'uu' then 'University of Utah Regional Seismic Network (UU)'
        when magsource = 'us' then 'United States National Seismic Network (US)'
        when magsource = 'uw' then 'Pacific Northwest Seismic Network - University of Washington (UW)'
        when magsource = 'zamg' then 'Zentralanstalt für Meterologie und Geodynamik (ZAMG)'
        else 'Unknown'
    end
 as network_magnitude_author_name
from 
    source_data
where rn = 1
;

