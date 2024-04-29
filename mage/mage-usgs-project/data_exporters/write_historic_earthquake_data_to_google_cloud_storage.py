import pyarrow as pa
import pyarrow.parquet as pq
import os
import pandas as pd
from datetime import datetime
import unittest

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


bucket_name = os.environ.get('GCP_GC_STORAGE_BUCKET_NAME')
today = datetime.now().date()
year = today.strftime("%Y")

root_path = f"{bucket_name}/"
object_key_template = "earthquakes/{year}/{month}/"


@data_exporter
def export_data(df):
    """
    Export DataFrame to Parquet files and store in Google Cloud Storage.

    Args: df (DataFrame): DataFrame containing earthquake data.
    
    """
    print("Converting 'time' column to datetime...")
    df['time'] = pd.to_datetime(df['time'], format='%d-%m-%Y')

    gcs = pa.fs.GcsFileSystem()

    # Iterate over each date and export partitioned data to Parquet files
    for date, partition_data in df.groupby(df['time'].dt.date):
        year = date.year
        month = date.month
        day = date.day
        
        object_key = object_key_template.format(year=year, month=str(month).zfill(2))
        partition_folder = os.path.join(root_path, object_key)
        partition_file_name = f"{day:02d}-{month:02d}-{year}-earthquakes-usgs.parquet"
        partition_file_path = os.path.join(partition_folder, partition_file_name)
        
        # Create the folder if it doesn't exist
        try:
            gcs.mkdir(partition_folder)
            print(f"Created folder: {partition_folder}")
        except Exception as e:
            pass
        
        # Convert partition data to Arrow table and write to Parquet file
        partition_table = pa.Table.from_pandas(partition_data)
        pq.write_table(partition_table, partition_file_path, filesystem=gcs)
        print(f"Exported data for {day:02d}-{month:02d}-{year} to: {partition_file_path}")




# Unit Test Block

@test
class TestDataExporter(unittest.TestCase):
    """

    Unit tests for the export_data_to_big_query function.

    This test suite verifies the functionality of the export_data_to_big_query function,
    which exports earthquake data to a BigQuery warehouse. The tests ensure that the function
    correctly exports the data, including partitioning and clustering configurations, and that
    the exported data conforms to the expected format.

    Test Cases:
    - test_export_data_output_and_format: Checks if the function generates output files in the specified Google Cloud Storage bucket
      and verifies the format of the exported Parquet files.
      
    """

    def setUp(self):
        # Create a DataFrame for testing (2023 before our first data point of 2024)
        self.df = pd.DataFrame({
            'time': pd.date_range(start='01-01-2023', end='01-01-2023'),
            'magnitude': [5.0, 6.2, 4.5]
        })

    def test_export_data_output_and_format(self):
        """
        Test if the function generates output files and check their format.
        """
        export_data(self.df)

        # Check if the Parquet files exist in the specified bucket and directory
        bucket_name = os.environ.get('GCP_GC_STORAGE_BUCKET_NAME')
        today = datetime.now().date()
        year = today.strftime("%Y")
        object_key_template = "earthquakes/{year}/{month}/"

        for date in pd.date_range(start='01-04-2024', end='03-04-2024'):
            year = date.year
            month = date.month
            day = date.day
            object_key = object_key_template.format(year=year, month=str(month).zfill(2))
            partition_file_name = f"{day:02d}-{month:02d}-{year}-earthquakes-usgs.parquet"
            partition_file_path = os.path.join(bucket_name, object_key, partition_file_name)

            self.assertTrue(pa.fs.GcsFileSystem().exists(partition_file_path))

            # Read the exported Parquet files and check their format
            table = pq.read_table(partition_file_path)

            # Check if the column names and data types match the original DataFrame
            self.assertListEqual(table.column_names, ['time', 'magnitude'])
            self.assertEqual(table[0][0].type, pa.timestamp('us'))
            self.assertEqual(table[0][1].type, pa.float64())

    def cleanup(self):
        # Clean up - delete files created (delete 2023 folder)
        bucket_name = os.environ.get('GCP_GC_STORAGE_BUCKET_NAME')
        folder_to_delete = "earthquakes/2023"

        gcs = pa.fs.GcsFileSystem()
        if gcs.exists(folder_to_delete):
            gcs.delete_dir(folder_to_delete)