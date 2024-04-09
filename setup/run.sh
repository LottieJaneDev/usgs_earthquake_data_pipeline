#!/bin/bash

########## RUNNING MAGE-AI WORKFLOW ORCHESTRATION IN A DOCKER CONTAINER###############

# starting in usgs_earthquake_data/setup - SEE WHERE THEY END UP BEING AFTER DOING THE ABOVE AND WORK OUT WHERE TO START THE SHELL 
# cd back to repo root 
cd ..

source_directory="/home/${USER}/.gcp"
destination_directory="/home/${USER}/usgs_earthquake_data/src/mage/"
sudo cp -r "$source_directory" "$destination_directory"

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

# Print the link to localhost port 6789
echo "Please Access the Mage UI here: http://localhost:6789"

# may need to add the code back in to forward the port automatically 

echo "This script will now trigger the main pipeline of the project"

sleep 15

# need to cd to the main mage project here before running docker exec 

# start the project 
docker run -it -p 6789:6789 -v $(pwd):/home/src mageai/mageai /app/run_app.sh mage start [project_name]

# trigger the piepline
docker exec mage mage run /home/src/src/mage/mage-usgs-project usgs_earthquake_data_ingest_historic