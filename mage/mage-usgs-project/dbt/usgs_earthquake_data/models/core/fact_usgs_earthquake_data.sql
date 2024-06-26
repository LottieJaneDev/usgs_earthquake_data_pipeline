{{ config(
    materialized='table',
    partition_by={
        "field": "event_date",
        "data_type": "date",
        "granularity": "day"
    },
    cluster_by=["event_type", "event_magnitude", "network_reported_by_name"]
)}}

select
    -- identifiers
    unique_event_id,
    event_id,

    -- date/time data
    event_datetime,
    event_date,
    event_time,

    -- event data 
    event_type,
    event_magnitude,
    magnitude_alert_level,
    event_review_status,
    last_updated,

    -- location data
    descriptive_geographic_region,
    event_latitude,
    event_longitude,
    depth_km,

    -- seismic data
    magnitude_conversion_type_id,
    magnitude_conversion_type_name,
    no_stations_to_calculate_location,
    no_stations_to_calculate_magnitude,
    largest_gap_between_stations,
    dist_epicenter_to_station_degrees,
    root_mean_square_residual_seconds,
    horizontal_location_error_km,
    depth_uncertainty_km,
    magnitude_uncertainty,
    
    -- network data
    data_contributor_network_id,
    data_contributor_network_name,
    network_reported_by_id,
    network_reported_by_name,
    network_magnitude_author_id,
    network_magnitude_author_name

from 
    {{ ref('staging_usgs_earthquake_data') }}

{% if var("is_test_run", default=true) %} limit 100 {% endif %}
