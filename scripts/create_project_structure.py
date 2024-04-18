import os

def project_structure(root_directory, indent=""):
    """
    Return project structure for README - Omit directories in .gitignore
    """
    if not os.path.exists(root_directory):
        print(f"Directory '{root_directory}' does not exist.")
        return

    # Print the current working directory
    print(indent + "├── " + os.path.basename(root_directory) + "/")

    # Get list of sub-directories
    subdirectories = [
        d for d in os.listdir(root_directory) if os.path.isdir(os.path.join(root_directory, d))
    ]
    subdirectories.sort()


    # Directories to be excluded
    exclude_directories = [".git", ".terraform", ".ssh_tunnel", "mage_data", "__pycache__", "logs", 
                        "dbt_packages", ".profiles_interpolated_temp_0e225d18-2394-44b1-90e4-c1adf8275538", 
                        ".profiles_interpolated_temp_47f4f3d9-58b9-4b45-97d7-4024396f0f09",
                        ".profiles_interpolated_temp_8226750a-6b99-458f-bb36-03fcc03bb310",
                        ".profiles_interpolated_temp_844dc124-549b-4ae9-9d60-bb2065b9f065",
                        ".profiles_interpolated_temp_97ee1e01-31fd-48f6-9eb6-21a9a4c37939",
                        ".profiles_interpolated_temp_985d10f2-fcd5-43df-af65-0ab5476bd38f",
                        ".profiles_interpolated_temp_b863180c-9e1d-4e4f-a3b9-d6f12d7366dc",
                        ".profiles_interpolated_temp_d31cdea2-317e-472f-9f6e-c603d15fe047", "metadata.yml"]


    # Recursive call for subdirectories & skip excluded directories
    for idx, subdirectory in enumerate(subdirectories):
        subdir_path = os.path.join(root_directory, subdirectory)  # Corrected line
        if subdirectory in exclude_directories:
            continue 
        is_last = idx == len(subdirectories) - 1
        project_structure(subdir_path, indent + ("    " if is_last else "│   "))


# Replace with your file path:
project_structure(
    r"/home/lottie/usgs_earthquake_data_pipeline/"
)
