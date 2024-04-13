
  
    

    create or replace table `usgs-earthquake-data`.`usgs_earthquake_data`.`schema_codegen`
      
    
    

    OPTIONS()
    as (
      version: 2

models:
  - name: fact_usgs_earthquake_data
    description: ""
    columns:
      - name: unique_event_id
        data_type: string
        description: ""

      - name: event_id
        data_type: string
        description: ""

      - name: event_datetime
        data_type: timestamp
        description: ""

      - name: event_date
        data_type: date
        description: ""

      - name: event_time
        data_type: time
        description: ""

      - name: descriptive_geographic_region
        data_type: string
        description: ""

      - name: event_type
        data_type: string
        description: ""

      - name: event_latitude
        data_type: float64
        description: ""

      - name: event_longitude
        data_type: float64
        description: ""

      - name: depth_km
        data_type: numeric
        description: ""

      - name: last_updated
        data_type: timestamp
        description: ""

      - name: event_review_status
        data_type: string
        description: ""

      - name: event_magnitude
        data_type: numeric
        description: ""

      - name: magnitude_alert_level
        data_type: string
        description: ""

      - name: magnitude_conversion_type
        data_type: string
        description: ""

      - name: magnitude_type_method
        data_type: string
        description: ""

      - name: no_stations_to_calculate_location
        data_type: numeric
        description: ""

      - name: largest_gap_between_stations
        data_type: numeric
        description: ""

      - name: dist_epicenter_to_station_degrees
        data_type: numeric
        description: ""

      - name: root_mean_square_residual_seconds
        data_type: numeric
        description: ""

      - name: horizontal_location_error_km
        data_type: numeric
        description: ""

      - name: depth_uncertainty_km
        data_type: numeric
        description: ""

      - name: magnitude_uncertainty
        data_type: numeric
        description: ""

      - name: no_stations_to_calculate_magnitude
        data_type: numeric
        description: ""

      - name: data_contributor_network_id
        data_type: string
        description: ""

      - name: data_contributor_network_name
        data_type: string
        description: ""

      - name: network_reported_by_id
        data_type: string
        description: ""

      - name: network_reported_by_name
        data_type: string
        description: ""

      - name: network_magnitude_author_id
        data_type: string
        description: ""

      - name: network_magnitude_author_name
        data_type: string
        description: ""

    );
  