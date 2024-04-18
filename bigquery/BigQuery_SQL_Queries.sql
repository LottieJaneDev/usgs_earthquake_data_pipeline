
-- RAW DATA TABLE QUERIES 

-- list the columns in the dataset

SELECT column_name
FROM `usgs-earthquake-data.usgs_earthquake_data.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'usgs_earthquake_data_raw_2024';

-- show distinct values in a column 

SELECT DISTINCT date_partition # <-- change column required here
FROM `usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024`;

------------------------------------------------------------------------------------------

-- show all rows, newest first

SELECT * FROM `usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024` 
ORDER BY time DESC;

------------------------------------------------------------------------------------------

-- show all rows over 5 magnitude, newest first

SELECT time, depth, mag, place
FROM `usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024` 
WHERE mag > 5
ORDER BY time DESC;

------------------------------------------------------------------------------------------

-- check for duplicate rows in

WITH DuplicateRows AS (
    SELECT *,
           COUNT(*) OVER (PARTITION BY date_partition, id) AS duplicate_count
    FROM `usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024`
)
SELECT t1.*
FROM `usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024` t1
JOIN DuplicateRows t2
ON t1.date_partition = t2.date_partition
AND t1.id = t2.id
WHERE t2.duplicate_count > 1;


------------------------------------------------------------------------------------------

-- DEDUPLICATE DATA

-- Execute a MERGE statement where all original rows are deleted,
-- then replaced with new, deduplicated rows (this is the only way to do this as it's difficult 
-- to perform deduplication on a partitioned table without writing to a new table)
-- the DBT staging model will handle duplicates before they get to the dashboard BUT for 
-- earlier analysis of raw data use this statement if you accidentally run the pipeline incorrectly
-- and end up with duplicate data - be careful of costs being incurred (top right corner of this window)

MERGE usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024 AS t1
USING (
    SELECT DISTINCT *
    FROM usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024
) AS t2
ON FALSE
WHEN NOT MATCHED BY TARGET THEN INSERT ROW
WHEN NOT MATCHED BY SOURCE THEN DELETE;

--or....----------------------------------------------------------------------------------------

MERGE usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024 AS t1
USING (
    SELECT
        time,
        latitude,
        longitude,
        depth,
        mag,
        magType,
        nst,
        gap,
        dmin,
        rms,
        net,
        id,
        updated,
        place,
        type,
        horizontalError,
        depthError,
        magError,
        magNst,
        status,
        locationSource,
        magSource,
        mag_cluster,
        date_partition
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY date_partition, id ORDER BY time DESC) AS row_num
        FROM usgs-earthquake-data.usgs_earthquake_data.usgs_earthquake_data_raw_2024
    ) AS sorted_data
    WHERE row_num = 1
) AS t2
ON FALSE
WHEN NOT MATCHED BY TARGET THEN INSERT ROW
WHEN NOT MATCHED BY SOURCE THEN DELETE;

-----------------------------------



