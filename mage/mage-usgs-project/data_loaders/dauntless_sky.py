import os
import requests
import zipfile

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs):
    """
    Template code for loading data from any source.

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Define the URL of the shapefile
    shapefile_url = "https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries_lakes.zip"

    # Define the local directory to save the downloaded shapefile
    local_directory = "shapefile_data"

    # Make sure the local directory exists
    os.makedirs(local_directory, exist_ok=True)

    # Download the shapefile
    shapefile_zip_path = os.path.join(local_directory, "ne_10m_admin_0_countries_lakes.zip")
    with open(shapefile_zip_path, "wb") as f:
        response = requests.get(shapefile_url)
        f.write(response.content)

    # Extract the shapefile from the zip archive
    with zipfile.ZipFile(shapefile_zip_path, 'r') as zip_ref:
        # Extract only the .shp file
        shp_files = [file for file in zip_ref.namelist() if file.endswith('.shp')]
        if shp_files:
            shapefile_shp_path = os.path.join(local_directory, shp_files[0])
            with zip_ref.open(shp_files[0]) as source, open(shapefile_shp_path, 'wb') as target:
                shutil.copyfileobj(source, target)

    print(f"Shapefile {shp_files[0]} extracted successfully!")

    return {}


