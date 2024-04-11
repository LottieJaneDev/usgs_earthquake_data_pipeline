#!/bin/bash

########## RUNNING MAGE-AI WORKFLOW ORCHESTRATION IN A DOCKER CONTAINER###############

# cd back to repo root 
cd

# copy the service account keys into the Mage folder to access inside the container
source_directory="/home/${USER}/.gcp"
destination_directory="/home/${USER}/usgs_earthquake_data/src/mage/"
sudo cp -r "$source_directory" "$destination_directory"

# cd to the project root where the docker-compose.yaml file lives
cd && cd usgs_earthquake_data/

# Start containers using docker-compose up -d in detached mode
echo "Starting containers..."
docker-compose up -d

# Check if containers started successfully before continuing
if [ $? -eq 0 ]; then
    echo "Containers started successfully."
else
    echo "Failed to start containers. Exiting script."
    exit 1
fi

echo "The Mage Docker container is now up and running."

sleep 3

echo "Automatically forwarding port 6789 to access the container locally..."

sleep 3

# automatic port forwarding to access Docker container locally 
docker exec -d mage sh -c "code-server --port 6789 --auth none --disable-telemetry &"

# Print the link to localhost port 6789
echo "Please Access the Mage UI here: http://localhost:6789"

# may need to add the code back in to forward the port automatically 

echo "The project is now available to view in the above UI & the pipeline triggers have started automatically populating your database!"


