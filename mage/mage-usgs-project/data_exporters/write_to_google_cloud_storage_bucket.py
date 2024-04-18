from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path
import os
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from datetime import datetime
import unittest
from unittest.mock import patch, MagicMock

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

@data_exporter
def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    bucket_name = os.environ.get('GCP_GC_STORAGE_BUCKET_NAME')
    today = datetime.now().date()
    year, month, date = today.strftime("%Y"), today.strftime("%m"), today.strftime("%d-%m-%Y")
    object_key = f"earthquakes/{year}/{month}/{date}-earthquakes-usgs.parquet"

    # Check if the file exists
    file_exists = GoogleCloudStorage.with_config(ConfigFileLoader(config_path, config_profile)).exists(
        bucket_name,
        object_key
    )

    if file_exists:
        print(f'File for {date} already exists')
        existing_table = pq.read_table(f"gs://{bucket_name}/{object_key}")
        existing_df = existing_table.to_pandas()

        # Merge and remove duplicates
        merged_df = pd.concat([existing_df, df]).drop_duplicates()

        merged_table = pa.Table.from_pandas(merged_df)
        pq.write_table(merged_table, f"gs://{bucket_name}/{object_key}")

        num_new_rows = len(merged_df) - len(existing_df)
        print(f"No. of New Records Written: {num_new_rows}")

    else:
        print(f'Parquet file for {date} not found. Creating a new one...')
        
        table = pa.Table.from_pandas(df)
        pq.write_table(table, f"gs://{bucket_name}/{object_key}")
        num_new_rows = len(df)

    total_rows = len(merged_df) if file_exists else len(df)

    print(f"Total number of rows in the file: {total_rows}")
    print(f"\nData exported to {bucket_name}/{object_key} in Google Cloud Storage")


@test
class TestDataExporterToGoogleCloudStorage(unittest.TestCase):

    def setUp(self):
        # Create a sample DataFrame for testing
        self.df = pd.DataFrame({
            'time': pd.date_range(start='2023-04-01', end='2023-04-03'),
            'magnitude': [5.0, 6.2, 4.5]
        })

    @patch('mage_ai.exporter.GoogleCloudStorage.with_config')
    @patch('mage_ai.exporter.pq.write_table')
    def test_export_data_to_google_cloud_storage(self, mock_write_rows, mock_with_config):
        
        # acts as if file doesn't already exist 
        mock_exists = MagicMock(return_value=False)
        mock_with_config.return_value.exists = mock_exists

        export_data_to_google_cloud_storage(self.df)

        # Check if the Parquet file is written
        mock_write_rows.assert_called_once()

    @patch('mage_ai.exporter.GoogleCloudStorage.with_config')
    @patch('mage_ai.exporter.pq.read_table')
    @patch('mage_ai.exporter.pq.write_table')
    def test_export_data_to_google_cloud_storage_update(self, mock_write_rows, mock_read_rows, mock_with_config):
        # Mock existing table
        existing_df = pd.DataFrame({
            'time': pd.date_range(start='2024-04-01', end='2024-04-02'),
            'magnitude': [3.0, 4.5]
        })

        # returns as though a file already exists
        mock_read_rows.return_value.to_pandas.return_value = existing_df

        mock_exists = MagicMock(return_value=True)
        mock_with_config.return_value.exists = mock_exists

        export_data_to_google_cloud_storage(self.df)

        # Check if the Parquet file is updated with merged data
        mock_write_rows.assert_called_once()