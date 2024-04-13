{{ config(materialized="table") }}

with
    source_data_partitioned as (
        select *, row_number() over (partition by id, time order by updated desc) as rn
        from {{ source("staging", "usgs_earthquake_data_raw_2024") }}
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
    {{ dbt_utils.generate_surrogate_key(["id", "time"]) }} as unique_event_id,
    {{ dbt.safe_cast("id", "string") }} as event_id,
    {{ dbt.safe_cast("time_timestamp", "timestamp") }} as event_datetime,
    {{ dbt.safe_cast("updated", "timestamp") }} as last_updated,
    {{ dbt.safe_cast("event_date", "date") }} as event_date,
    {{ dbt.safe_cast("event_time", "time") }} as event_time,
    {{ dbt.safe_cast("date_partition", "date") }} as date_partition,
    coalesce(cast(mag_cluster as string), 'Unknown') as mag_cluster_partition,
    -- location
    {{ dbt.safe_cast("latitude", "Float64") }} as event_latitude,
    {{ dbt.safe_cast("longitude", "Float64") }} as event_longitude,
    coalesce(cast(place as string), 'Unknown') as descriptive_geographic_region,
    -- seismic data
    coalesce(cast(type as string), 'Unknown') as event_type,
    cast(mag as numeric) as event_magnitude,
    {{ get_mag_alert_level('mag') }} as magnitude_alert_level,
    cast(depth as numeric) as depth_km,
    coalesce(cast(magtype as string), 'Unknown') as magnitude_conversion_type_id,
    {{ get_mag_type_conversion_name('magtype')}} as magnitude_conversion_type_name,
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
    {{ get_network_names("net") }} as data_contributor_network_name,
    coalesce(cast(locationsource as string), 'Unknown') as network_reported_by_id,
    {{ get_network_names("locationsource") }} as network_reported_by_name,
    coalesce(cast(magsource as string), 'Unknown') as network_magnitude_author_id,
    {{ get_network_names("magsource") }} as network_magnitude_author_name
from 
    source_data
where rn = 1
{% if var("is_test_run", default=true) %} limit 100 {% endif %}
