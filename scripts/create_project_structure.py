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
    exclude_directories = [".git", ".terraform", ".ssh_tunnel", "mage_data", "__pycache__"]

    # Recursive call for subdirectories & skip excluded directories
    for idx, subdirectory in enumerate(subdirectories):
        subdir_path = os.path.join(root_directory, subdirectory)  # Corrected line
        if subdirectory in exclude_directories:
            continue 
        is_last = idx == len(subdirectories) - 1
        project_structure(subdir_path, indent + ("    " if is_last else "│   "))


# Replace with your file path:
project_structure(
    r"/home/lottie/usgs_earthquake_data"
)
