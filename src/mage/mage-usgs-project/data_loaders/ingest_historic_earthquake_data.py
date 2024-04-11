import io
import pandas as pd
import requests
from datetime import datetime, timedelta

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api():
    """
    Ingest historic earthquake data from the USGS Earthquake API.

    Returns:
        DataFrame: DataFrame containing earthquake data.
    """

    # DEFAULT BLOCK - USE THIS BLOCK FOR LAST 30 DAYS OF DATA LINK

    # url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
    # response = requests.get(url)
    # return pd.read_csv(io.StringIO(response.text), sep=',')

    #-------------------------------------------------------------------------------

    # ADVANCED OPTION - USE THIS BLOCK TO GATHER DATA FOR YOUR REQUIRED TIME PERIOD

    ##### SPECIFY THE TIME PERIOD YOU WANT TO INGEST #####
    ##### LIMITED TO 20,000 ROWS PER CALL BUT NO CALL LIMIT #####

    # start_time = "2024-01-01T00:00:00"
    # end_time = "2024-02-15T00:00:00"

    # start_time = "2024-02-15T00:00:00"
    # end_time = "2024-04-10T00:00:00"

    # start_time = "2024-04-10T00:00:00"
    # end_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S") # END TIME = NOW
    
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