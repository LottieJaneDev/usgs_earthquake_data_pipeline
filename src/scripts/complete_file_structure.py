import os

def project_structure(root_directory, indent=""):
    """
    Return project structure for README - Include all files
    """
    if not os.path.exists(root_directory):
        print(f"Directory '{root_directory}' does not exist.")
        return

    # Initialize the output string
    output = ""

    # Function to add a line to the output
    def add_line(line):
        nonlocal output
        output += line + "\n"

    # Function to recursively traverse directories
    def traverse_directory(directory, indent):
        nonlocal output
        add_line(indent + "├── " + os.path.basename(directory) + "/")
        files_and_directories = os.listdir(directory)

        # Sort directories first, then files
        directories = sorted([d for d in files_and_directories if os.path.isdir(os.path.join(directory, d))])
        files = sorted([f for f in files_and_directories if os.path.isfile(os.path.join(directory, f))])

        # Print directories
        for idx, subdir in enumerate(directories):
            subdir_path = os.path.join(directory, subdir)
            is_last = idx == len(directories) - 1 and len(files) == 0
            traverse_directory(subdir_path, indent + ("    " if is_last else "│   "))

        # Print files
        for idx, file in enumerate(files):
            is_last = idx == len(files) - 1
            add_line(indent + ("└── " if is_last else "├── ") + file)

    # Start traversing the root directory
    traverse_directory(root_directory, "")

    # Save the output to a file
    with open("output.md", "w") as f:
        f.write("```bash\n")
        f.write(output)
        f.write("```")

# Replace with your file path:
project_structure(
    r"/home/lottie/usgs_earthquake_data"
)
