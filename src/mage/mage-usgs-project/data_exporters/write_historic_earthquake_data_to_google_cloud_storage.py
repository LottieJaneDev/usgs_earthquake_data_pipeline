import pyarrow as pa
import pyarrow.parquet as pq
import os
import pandas as pd
from datetime import datetime

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

# os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = os.environ.get['MAGE_GOOGLE_SERVICE_ACCOUNT']

bucket_name = os.environ.get('GCP_GC_STORAGE_BUCKET_NAME')
today = datetime.now().date()
year = today.strftime("%Y")

root_path = f"{bucket_name}/"
object_key_template = "earthquakes/{year}/{month}/"

@data_exporter
def export_data(data, *args, **kwargs):
    
    # Get date from 'time' column 
    data['time'] = pd.to_datetime(data['time'], format='%d-%m-%Y')
    
    gcs = pa.fs.GcsFileSystem()

    for date, partition_data in data.groupby(data['time'].dt.date):
        year = date.year
        month = date.month
        day = date.day
        
        object_key = object_key_template.format(year=year, month=str(month).zfill(2))
        partition_folder = os.path.join(root_path, object_key)
        partition_file_name = f"{year}-{month:02d}-{day:02d}-earthquakes-usgs.parquet"
        partition_file_path = os.path.join(partition_folder, partition_file_name)
        
        # Create the folder if it doesn't exist
        try:
            gcs.mkdir(partition_folder)
        except Exception as e:
            pass
        
        partition_table = pa.Table.from_pandas(partition_data)
        pq.write_table(partition_table, partition_file_path, filesystem=gcs)

