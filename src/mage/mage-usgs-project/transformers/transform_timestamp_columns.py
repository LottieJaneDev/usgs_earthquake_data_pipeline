import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(df, *args, **kwargs):
    """

    transforms time columns as string to datetime

    """
    # Specify your transformation logic here

    # Convert 'time' column to datetime with milliseconds precision
    df['time'] = pd.to_datetime(df['time'], format='%Y-%m-%d %H:%M:%S.%f')
    # Convert 'updated' column to datetime with milliseconds precision
    df['updated'] = pd.to_datetime(df['updated'], format='%Y-%m-%d %H:%M:%S.%f')
    
    return df