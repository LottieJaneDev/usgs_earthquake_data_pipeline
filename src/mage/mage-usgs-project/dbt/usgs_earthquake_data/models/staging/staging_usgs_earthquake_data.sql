-- {{ config(materialized="table") }}

-- select * from {{ source("staging", "usgs_earthquake_data_raw_2024") }}

{{ config(materialized="table") }}

with
    source_data_partitioned as (
        select *,
               row_number() over (partition by id, time order by updated desc) as rn
        from {{ source("staging", "usgs_earthquake_data_raw_2024") }}
        where time is not null
    ),
    source_data as (
        select *,
               cast(time as timestamp) as time_timestamp,
               cast(time as date) as event_date,
               cast(time as time) as event_time
        from source_data_partitioned
    )
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(["id", "time"]) }} as unique_event_id,
    {{ dbt.safe_cast("id", "string") }} as event_id,
    {{ dbt.safe_cast("time_timestamp", "timestamp") }} as event_datetime,
    {{ dbt.safe_cast("updated", "timestamp") }} as last_updated,
    {{ dbt.safe_cast("event_date", "date") }} as event_date, 
    {{ dbt.safe_cast("event_time", "time") }} as event_time,
    -- location
    {{ dbt.safe_cast("latitude", "Float64") }} as event_latitude,
    {{ dbt.safe_cast("longitude", "Float64") }} as event_longitude,
    -- seismic data
    cast(depth as numeric) as depth_km,
    cast(mag as numeric) as event_magnitude,
    cast(magtype as string) as magnitude_conversion_type,
    cast(nst as numeric) as no_stations_to_calculate_location,
    cast(gap as decimal) as largest_gap_between_stations,
    cast(dmin as decimal) as dist_epicenter_to_station_degrees,
    cast(rms as decimal) as root_mean_square_residual_seconds,
    cast(net as string) as data_contributor_network_id,
    cast(place as string) as descriptive_geographic_region,
    cast(type as string) as event_type,
    cast(horizontalerror as decimal) as horizontal_location_error_km,
    cast(deptherror as decimal) as depth_uncertainty_km,
    cast(magerror as decimal) as magnitude_uncertainty,
    cast(magnst as numeric) as no_stations_to_calculate_magnitude,
    cast(status as string) as event_review_status,
    cast(locationsource as string) as network_reported_by,
    cast(magsource as string) as network_magnitude_author

from source_data

where rn = 1

{% if var("is_test_run", default=true) %} limit 100 {% endif %}
