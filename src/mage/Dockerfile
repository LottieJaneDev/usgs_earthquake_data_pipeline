FROM mageai/mageai:latest

ARG USER_CODE_PATH=/home/src/src/mage/${MAGE_PROJECT_NAME}

# Set working directory
WORKDIR ${USER_CODE_PATH}

# Copy the requirements.txt file from the build context into the docker container
COPY requirements.txt .

# Install requirements.txt into your MAGE docker environment for use in your project 
RUN pip3 install -r requirements.txt