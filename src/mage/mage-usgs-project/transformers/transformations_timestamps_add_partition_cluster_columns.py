import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(df):
    """

    Transform the DataFrame by converting time columns to datetime, creating partition columns,
    and clustering columns.

    Args: df (DataFrame): Input DataFrame containing earthquake data.

    Returns: DataFrame: Transformed with datetime columns and additional partition & clustering columns.

    """
    
    # Convert 'time' column to datetime with milliseconds precision
    df['time'] = pd.to_datetime(df['time'], format='%Y-%m-%d %H:%M:%S.%f')

    # Convert 'updated' column to datetime with milliseconds precision
    df['updated'] = pd.to_datetime(df['updated'], format='%Y-%m-%d %H:%M:%S.%f')
   
    # Preprocess DataFrame to create a new column for clustering
    df['mag_cluster'] = pd.cut(df['mag'], 
        bins=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 
        labels=['0-1', '1-2', '2-3', '3-4', '4-5', '5-6', '6-7', '7-8', '8-9', '9-10'])

    # Create a new column for the date partition - BigQuery only except 'TIMESTAMP, DATETIME or DATE'
    # I want to preserve the exact timestamp in milliseconds (datetime64[ns, UTC]) for analysis 
    df['date_partition'] = df['time'].dt.date
    
    return df


@test
def test_transform_time_columns(df):
    """
    Test to ensure time columns are converted to datetime objects.
    """
    assert isinstance(df['time'].dtype, pd.core.dtypes.dtypes.DatetimeTZDtype), "The 'time' column is not converted to datetime"
    assert isinstance(df['updated'].dtype, pd.core.dtypes.dtypes.DatetimeTZDtype), "The 'updated' column is not converted to datetime"

@test
def test_transform_mag_cluster_column(df):
    """
    Test to ensure 'mag_cluster' column is correctly created.
    """
    assert 'mag_cluster' in df.columns, "The 'mag_cluster' column is not created"

@test
def test_transform_date_partition_column(df):
    """
    Test to ensure 'date_partition' column is correctly created.
    """
    assert 'date_partition' in df.columns, "The 'date_partition' column is not created"
    assert df['date_partition'].dtype == 'object', "The 'date_partition' column is not of type 'object' (string)"
