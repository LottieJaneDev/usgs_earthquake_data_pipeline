#!/bin/bash

########## RUNNING MAGE-AI WORKFLOW ORCHESTRATION IN A DOCKER CONTAINER###############

# starting in usgs_earthquake_data/setup - SEE WHERE THEY END UP BEING AFTER DOING THE ABOVE AND WORK OUT WHERE TO START THE SHELL 
# cd back to repo root 
cd ..

# Load environment variables - DON'T THINK THIS IS NECESSARY ACCORDING TO CGPT & SLACK
source .env

# Build Docker images to ensure latest images are pulled & Build | Start containers using docker-compose up -d in detatched mode
echo "Building Mage Docker Container..."
docker-compose build

# Check if build was successful before continuing
if [ $? -eq 0 ]; then
    echo "Build completed successfully."
else
    echo "Build failed. Exiting script."
    exit 1
fi

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

echo "All tasks completed successfully."

sleep 3

# Print the link to localhost port 6789
echo "Access the Mage UI here: http://localhost:6789"