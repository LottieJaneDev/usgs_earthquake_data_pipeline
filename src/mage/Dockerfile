FROM mageai/mageai:latest

ARG USER_CODE_PATH=/home/src/${MAGE_PROJECT_NAME}

# copies the requirements.txt file from your virtual machine into the docker container
COPY requirements.txt ${USER_CODE_PATH}/requirements.txt 

# install's requirments.txt into your MAGE docker environment for use in your project 
RUN pip3 install -r ${USER_CODE_PATH}/requirements.txt

# DON'T THINK I NEED TO DO THIS BUT JUST IN CASE - as the .env's should be passed into the container
# Create a directory for the service account keys
# RUN mkdir -p ${USER_CODE_PATH}service_account_keys