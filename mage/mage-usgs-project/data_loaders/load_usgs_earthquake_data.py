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
    Ingests earthquake data from the USGS Earthquake API in 30 minute increments.
    Trigger is set to run the pipeline every 30 minutes.

    Returns: DataFrame: DataFrame containing earthquake data for previous 30 minutes. 
    """

    # USE FOR 30 MINUTE INCREMENTS IN THE PAST

    start_time = (datetime.now() - timedelta(minutes=30)).strftime("%Y-%m-%dT%H:%M:%S")
    end_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")

    # USE IF YOU WANT TO RUN A BACKFILL BUT IDEALLY USE THE BACKFILL FUNCTION FROM THE LEFT HAND MENU

    # start_time = "2024-04-09T00:00:00" 
    # end_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    
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
