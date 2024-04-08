import io
import pandas as pd
import requests
from datetime import datetime, timedelta

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    
    # USE FOR 30 MINUTE INCREMENTS IN THE PAST
    end_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    start_time = (datetime.now() - timedelta(minutes=30)).strftime("%Y-%m-%dT%H:%M:%S")
    
    # USE IF YOU WANT TO RUN A BACKFILL BUT IDEALLY USE THE BACKFILL FUNCTION
    # end_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    # start_time = "2024-02-15T00:00:00"  

    url = f"https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime={start_time}&endtime={end_time}"
    response = requests.get(url)
    return pd.read_csv(io.StringIO(response.text), sep=',')


@test
def test_number_of_columns(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    if output.shape[1] != 22:
        raise AssertionError('The number of columns is not equal to 22. Fail pipeline')

@test
def test_compulsory_data(dataframe):
    """
    Test to ensure the loaded data meets quality requirements.
    """
    required_columns = ['time', 'longitude', 'latitude']

    for col in required_columns:
        assert not dataframe[col].isnull().any(), f"Column '{col}' contains null values"