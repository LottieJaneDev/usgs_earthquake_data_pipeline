-- RAW TABLE QUERIES 

-- show distinct values in a column 

SELECT DISTINCT columnname
FROM `ny-taxi-rides-data.usgs_data.usgs_data_raw_2024`;


-- show all rows, newest first

SELECT * FROM `ny-taxi-rides-data.usgs_data.usgs_data_raw_2024` 
ORDER BY time DESC;

-- show all rows over 5 magnitude, newest first

SELECT time, depth, mag, place
FROM `ny-taxi-rides-data.usgs_data.usgs_data_raw_2024` 
WHERE mag > 5
ORDER BY time DESC;

-- check for duplicate rows in

SELECT t1.*
FROM `ny-taxi-rides-data.usgs_data.usgs_data_raw_2024` t1
JOIN (
    SELECT time, latitude, longitude
    FROM `ny-taxi-rides-data.usgs_data.usgs_data_raw_2024`
    GROUP BY time, latitude, longitude
    HAVING COUNT(*) > 1
) t2
ON t1.time = t2.time AND t1.latitude = t2.latitude AND t1.longitude = t2.longitude;

-- drop duplicate rows and overwrite the table with itself

CREATE OR REPLACE TABLE ny-taxi-rides-data.usgs_data.usgs_data_raw_2024 AS
SELECT DISTINCT *
FROM ny-taxi-rides-data.usgs_data.usgs_data_raw_2024;