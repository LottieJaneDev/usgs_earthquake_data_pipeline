from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
import pandas as pd
from os import path
import os
from google.cloud.bigquery import LoadJobConfig, TimePartitioning, TimePartitioningType, SchemaField
import unittest

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(df: DataFrame) -> None:
    """
    Export earthquake data to a BigQuery warehouse.

    Args: df (DataFrame): DataFrame containing earthquake data.

    Returns: None

    This function exports earthquake data to a BigQuery warehouse. It partitions the data by
    day using the 'date_partition' column and enables clustering on the specified fields 
    ['mag_cluster', 'locationSource', 'net'] to improve query performance & reduce query execution time.

    Documentation: https://docs.mage.ai/design/data-loading#bigquery
    """

    # Construct 'table_id'
    project_name = os.environ.get('GCP_PROJECT_NAME')
    dataset_name = os.environ.get('GCP_BIGQUERY_DATASET_NAME')
    table_name = 'usgs_earthquake_data_raw_2024'
    table_id = f'{project_name}.{dataset_name}.{table_name}'

    print(f"Exporting data to BigQuery table: {table_id}")

    # Load configuration settings
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    # define schema for parsing to loadconnfig
    schema = [
    SchemaField("time", "TIMESTAMP"),
    SchemaField("latitude", "FLOAT"),
    SchemaField("longitude", "FLOAT"),
    SchemaField("depth", "FLOAT"),
    SchemaField("mag", "FLOAT"),
    SchemaField("magType", "STRING"),
    SchemaField("nst", "FLOAT"),
    SchemaField("gap", "FLOAT"),
    SchemaField("dmin", "FLOAT"),
    SchemaField("rms", "FLOAT"),
    SchemaField("net", "STRING"),
    SchemaField("id", "STRING"),
    SchemaField("updated", "TIMESTAMP"),
    SchemaField("place", "STRING"),
    SchemaField("type", "STRING"),
    SchemaField("horizontalError", "FLOAT"),
    SchemaField("depthError", "FLOAT"),
    SchemaField("magError", "FLOAT"),
    SchemaField("magNst", "FLOAT"),
    SchemaField("status", "STRING"),
    SchemaField("locationSource", "STRING"),
    SchemaField("magSource", "STRING"),
    SchemaField("mag_cluster", "STRING"),
    SchemaField("date_partition", "DATE")
    ]

    # Initialize BigQuery client
    bigquery_client = BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).client

    # Configure job settings
    job_config = LoadJobConfig(
        schema=schema,
        write_disposition='WRITE_APPEND',
        time_partitioning=TimePartitioning(
            type_=TimePartitioningType.DAY,
            field="date_partition", 
            expiration_ms=None,
        ),
        clustering_fields=["mag_cluster", "locationSource", "net"]
    )
    
    # Load DataFrame to BigQuery table
    print("Loading data to BigQuery table...")
    job = bigquery_client.load_table_from_dataframe(df, table_id, job_config=job_config)
    result = job.result()

    # Get the number of rows written
    num_rows_written = result.output_rows
    print(f"{num_rows_written} rows written to BigQuery table.")

    print("Data export to BigQuery completed successfully.")



# Unit Test Block - test 2023 data

@test
class TestDataExporter(unittest.TestCase):
    """

    Unit tests for the export_data_to_big_query function.

    This test suite verifies the functionality of the export_data_to_big_query function,
    which exports earthquake data to a BigQuery warehouse. The tests ensure that the function
    correctly exports the data, including partitioning and clustering configurations, and that
    the exported data conforms to the expected format.

    Test Cases:
    - test_export_data_output_exists: Checks if the function generates output files in the specified Google Cloud Storage bucket.
    - test_exported_data_format: Reads the exported Parquet files and verifies that they conform to the expected format.
    
    """

    def setUp(self):
        # Create a sample DataFrame for testing - 2023 again 
        self.df = pd.DataFrame({
            'time': pd.date_range(start='2023-01-01', end='2024-01-03'),
            'mag_cluster': ['0-1', '1-2', '2-3'],
            'locationSource': ['A', 'B', 'C'],
            'net': ['X', 'Y', 'Z']
        })

        export_data_to_big_query(self.df)

    def test_job_config(self):
        # Test if the job config is set correctly
        job_config = export_data_to_big_query.job_config

        # Check write disposition
        self.assertEqual(job_config.write_disposition, 'WRITE_APPEND')

        # Check time partitioning configuration
        time_partitioning = job_config.time_partitioning
        self.assertIsInstance(time_partitioning, TimePartitioning)
        self.assertEqual(time_partitioning.type_, TimePartitioningType.DAY)
        self.assertEqual(time_partitioning.field, "date_partition")
        self.assertIsNone(time_partitioning.expiration_ms)

        # Check clustering fields
        self.assertListEqual(job_config.clustering_fields, ['mag_cluster', 'locationSource', 'net'])

    def tearDown(self):
        # Clean up BigQuery table after tests

        # Construct the table reference
        table_ref = client.dataset(dataset_name).table(table_name)

        # Delete rows from the table where the year is 2023
        query = f"DELETE FROM `{table_ref}` WHERE EXTRACT(YEAR FROM time) = 2023"
        client.query(query).result()