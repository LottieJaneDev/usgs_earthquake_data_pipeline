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
sleep 4

# Create a .env file at the repository root 
cd && cd usgs_earthquake_data_pipeline/
touch .env
rm example.env

# Function to prompt user for input and update .env file
update_env() {
    echo "Please enter the $1:"
    case $1 in
        "VM_NAME")
            echo "This is the name of the virtual machine you just created"
            ;;
        "LOCAL_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH")
            echo "This is the local file path to the Terraform service account JSON file on your personal computer"
            ;;
        "LOCAL_MAGE_SERVICE_ACCOUNT_FILE_PATH")
            echo "This is the local file path to the Mage service account JSON file on your personal computer"
            ;;
        "GCP_PROJECT_NAME")
            echo "This is the name of the Google Cloud Platform (GCP) project you just created e.g. usgs-data"
            ;;
        "GCP_LOCATION")
            echo "This is the geographical location of the GCP resource e.g. US  & should be the same as your project"
            ;;
        "GCP_REGION")
            echo "This is the GCP region where the resources will be deployed e.g. us-central1-c  & should be the same as your project"
            ;;
        "GCP_ZONE")
            echo "This is the GCP zone where the resources will be deployed e.g. us-central1 & should be the same as your project"
            ;;
        "GCP_GC_STORAGE_BUCKET_NAME")
            echo "This is the name of the Google Cloud Storage bucket e.g. usgs-raw-data"
            ;;
        "GCP_BIGQUERY_DATASET_NAME")
            echo "This is the name of the BigQuery dataset e.g. usgs_earthquake_data"
            ;;
        *)
            echo "Please provide a description for $1."
            ;;
    esac
    read -r value
    echo "$1=$value" >> .env
}

# Function to append custom lines to .env file
append_custom_lines() {
    echo "Appending custom lines to .env file..."
    cat <<EOF >> .env
# Custom lines added by script
ENV_FILE="/home/${USER}/usgs_earthquake_data_pipeline/.env"
VM_SERVICE_ACCOUNT_KEYS_FILE_PATH="/home/${USER}/.gcp/"
VM_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH="/home/$USER/.gcp/terraform-service-account.json" 
VM_MAGE_SERVICE_ACCOUNT_FILE_PATH="/home/${USER}/.gcp/mage-service-account.json"
MAGE_GOOGLE_SERVICE_ACCOUNT="/home/src/mage/.gcp/mage-service-account.json"
MAGE_PROJECT_NAME=mage-usgs-project
EOF
}

# Prompt user for each variable
update_env "VM_NAME"
update_env "LOCAL_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH"
update_env "LOCAL_MAGE_SERVICE_ACCOUNT_FILE_PATH"
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

cd 

export VM_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH="/home/${USER}/.gcp/terraform-service-account.json"
export VM_MAGE_SERVICE_ACCOUNT_FILE_PATH="/home/${USER}/.gcp/mage-service-account.json"

# Authorise the GCP Service Accounts we created earlier 
echo "Authorising Google Cloud Platform Service Accounts for Terraform & Mage.."
gcloud auth activate-service-account --key-file=$VM_TERRAFORM_SERVICE_ACCOUNT_FILE_PATH
gcloud auth activate-service-account --key-file=$VM_MAGE_SERVICE_ACCOUNT_FILE_PATH

# make sure that the VM's Operating System is up to day
sudo apt-get update

# tell the user what's about to happen as they'll need to interact with the shell to instlal Anaconda correctly 
echo "Anaconda is about to be installed"
echo "Please take a moment to review the Anaconda license agreement."
echo "Press Enter to scroll to the bottom."
echo "Once you've read the agreement, type 'yes' to agree to the terms and continue with the installation."
echo "Choose 'yes' or 'y' where prompted to complete the installation"
echo "After installation, you will see (base) at the start of your command line - this indicates that Anaconda is now the base interpreter"

# Install Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh
bash Anaconda3-2024.02-1-Linux-x86_64.sh -p $HOME/anaconda3 && rm Anaconda3-2024.02-1-Linux-x86_64.sh

# Add Anaconda to PATH
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Initialize conda
conda init bash

# Verify conda is installed correctly
conda --version

# Create a new environment (optional)
conda create --name myenv python=3.9

echo "=============================================================================="
echo "---------------------- ANACONDA3 INSTALLED! ----------------------"
echo "=============================================================================="

# initialise Anaconda as the base interpreter 
source ~/.bashrc

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

sleep 4

echo "========================================================================================================================="
echo "you will need to restart the SSH connection once this script has completed to be able to confirm the docker installation"
echo "========================================================================================================================="

sleep 8

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
echo "Head back to setup.md for the next steps!"
source ~/.bashrc
