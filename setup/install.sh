#!/bin/bash

########## INSTALLING ANACONDA, DOCKER, TERRAFORM ###############

# create a directory at the root of the virtual machine called '.gcp'
mkdir -p $HOME/.gcp

########## NOTE #######################
# sftp wouldn't work for me due to company restrictions
# gcloud compute scp wouldn't work due to windows file path not being read even after formatting 

# LAST RESORT: 
# ask user to drag and drop their GCP service keys to the virtual machine
echo "Please open your local file explorer and drop your Google Cloud service account .json files you created for previously into the new directory .gcp at the root of your virtual machine"
read -p "Press 'Y' once the file transfer is complete, or 'N' to exit: " choice

##### OTHER OPTIONS A & B FURTHER DOWN - MAY WORK ON ANOTHER MACHINE DUE TO WORK POLICIES ######
################################################################################################

# Check if the 'code' command is available (indicating Visual Studio Code is being used)
if command -v code &> /dev/null; then
    echo "Installing extensions for VS Code..."
    
    # Install Terraform extension (HashiCorp.terraform)
    echo "Installing Terraform extension (HashiCorp.terraform)..."
    code --install-extension HashiCorp.terraform
    
    # Install Docker extension (ms-azuretools.vscode-docker)
    echo "Installing Docker extension (ms-azuretools.vscode-docker)..."
    code --install-extension ms-azuretools.vscode-docker

    # Install Python extension (ms-python.python)
    echo "Installing Python extension (ms-python.python)..."
    code --install-extension ms-python.python
    
    echo "Extensions installed successfully."
else
    echo "Visual Studio Code is not in use. Skipping extension installation."
fi 


# sleep to read the above 
sleep 8

# Create a .env file at the repository root 
cd usgs_earthquake_data/
touch .env
rm example.env

###### NEED TO LIST ALL FINAL ENV. VARIABLES HERE AND ASK CHAT-GPT TO WRITE THIS AGAIN 

# Function to prompt user for input and update .env file
update_env() {
    echo "Enter value for $1:"
    read -r value
    echo "$1=$value" >> .env
}

# Function to append custom lines to .env file
append_custom_lines() {
    echo "Appending custom lines to .env file..."
    cat <<EOF >> .env
# Custom lines added by script
ENV_FILE="/home/${USER}/usgs_earthquake_data/.env"
VM_SERVICE_ACCOUNT_KEYS_FILE_PATH="/home/${USER}/.gcp/"
VM_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH="/home/$USER/.gcp/terraform-service-account.json" 
VM_MAGE_SERVICE_ACCOUNT_FILE_PATH="/home/${USER}/.gcp/mage-service-account.json"
MAGE_GOOGLE_SERVICE_ACCOUNT="~/mage/.gcp/mage-service-account.json"
EOF
}

# ADD IN A DESCRIPTION PRINT STATEMENT BEFORE EACH ONE SO THEY KNOW WHAT TO TYPE/PASTE
# Prompt user for each variable
update_env "VM_NAME"
update_env "LOCAL_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH"
update_env "LOCAL_MAGE_SERVICE_ACCOUNT_FILE_PATH"
update_env "MAGE_PROJECT_NAME"
update_env "GCP_PROJECT_NAME"
update_env "GCP_LOCATION"
update_env "GCP_REGION"
update_env "GCP_ZONE"
update_env "GCP_GC_STORAGE_BUCKET_NAME"
update_env "GCP_BIGQUERY_DATASET_NAME"

# Append custom lines to .env file
append_custom_lines

# Print all variables updated
echo "Variables updated in .env file."

#########################################################################
####### CAN'T GET THESE OPTIONS TO WORK SO MANUAL OPTION ABOVE ##########

# OPTION A:
# Transfer Service Account Keys with Safe File Transfer Protocol 

# sftp $VM_NAME <<EOF
# put ${LOCAL_MAGE_SERVICE_ACCOUNT_FILE_PATH} $HOME/.gcp/mage-service-account.json
# EOF

# sftp $VM_NAME <<EOF
# put ${LOCAL_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH} $HOME/.gcp/terraform-service-account.json
# EOF

# # OPTION B: 
# gcloud compute scp ${LOCAL_MAGE_SERVICE_ACCOUNT_FILE_PATH} ${USER}@${VM_NAME}:${VM_SERVICE_ACCOUNT_KEYS_FILE_PATH} --zone ${GCP_REGION}
# gcloud compute scp ${LOCAL_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH} ${USER}@${VM_NAME}:${VM_SERVICE_ACCOUNT_KEYS_FILE_PATH} --zone ${GCP_REGION}



##########################################################################

# Authorise the GCP Service Accounts we created earlier 
echo "Authorising Google Cloud Platform Service Accounts for Terraform & Mage.."
gcloud auth activate-service-account --key-file=$VM_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH
gcloud auth activate-service-account --key-file=$VM_MAGE_SERVICE_ACCOUNT_FILE_PATH

# make sure that the VM's Operating System is up to day
sudo apt-get update

# Install Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p $HOME/anaconda3
rm Anaconda3-2024.02-1-Linux-x86_64.sh

echo "=============================================================================="
echo "---------------------- ANACONDA3 INSTALLED! ----------------------"
echo "=============================================================================="

# Install Docker
sudo apt-get install -y docker.io
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo service docker restart
echo "you will need to restart the SSH connection once this script has completed to be able to confirm the docker installation"
sleep 4
docker run hello-world

echo "=============================================================================="
echo "---------------------- DOCKER INSTALLED! ----------------------"
echo "=============================================================================="

# Install Docker Compose
mkdir -p $HOME/bin
cd $HOME/bin || exit
wget https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-linux-x86_64 -O docker-compose
chmod +x docker-compose

# Add Docker Compose to PATH
echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.bashrc
source $HOME/.bashrc

echo "=============================================================================="
echo "---------------------- DOCKER COMPOSE INSTALLED! ----------------------"
echo "=============================================================================="

# Install Terraform
sudo apt-get install -y unzip
wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip terraform_1.7.5_linux_amd64.zip
rm terraform_1.7.5_linux_amd64.zip

echo "=============================================================================="
echo "---------------------- TERRAFORM INSTALLED! ----------------------"
echo "=============================================================================="

sleep 4

echo "=============================================================================="
echo "---------------------- FULL INSTALLATION COMPLETE! ----------------------"
echo "=============================================================================="

# check that we are in the right directory for this come the end... ?????
echo "!IMPORTANT - Log out of your Virtual Machine and log back in (Remote SSH Connection) to have your Docker group membership re-evaluated."
echo "You can then run `docker run hello-world` to confirm installation & configuration is complete"
sleep 5
echo "Remember to install your IDE alternative for Terraform & Docker formatting if required (not compulsory)."
echo "Head back to usgs_earthquake_data/setup.md for the next steps!"
source ~/.bashrc