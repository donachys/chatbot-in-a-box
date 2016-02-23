############################################################################### #                           Header Documentation                              # ############################################################################### 
# 
# Dockerfile to create container with following tools 
# - Yeoman 
# - Yeoman Hubot Generator
# 
############################################################################### #                                   Header                                    # ############################################################################### 
FROM centos:7
MAINTAINER SD <shaun@donachy.me>

############################################################################### #                            Environment Variables                            # ############################################################################### 
# Tar files for python and nodejs are downloaded to tmp directory 
ENV TMP_DIR /tmp 

# Docker user to be created to intereact with container. This user is 
# different than root 
ENV DOCKER_USER=docker 

# Password for the user defined by DOCKER_USER environment 
# variable 
ENV DOCKER_USER_PASSWORD=docker 

# Password for the root 
ENV ROOT_USER_PASSWORD=root 

############################################################################### #                                Instructions                                 # ############################################################################### 

# Install dependencies 
# wget is required to download npm tar files 
# build-essential is required for npm 
RUN yum update -y && yum install -y wget
RUN yum clean all;

# Set the current work directory to /tmp directory 
WORKDIR ${TMP_DIR} 

# Download nodejs 5.6.0 tar.
# It will be downloaded to temp directory which is current work directory 
RUN wget https://nodejs.org/dist/v5.7.0/node-v5.7.0-linux-x64.tar.gz

# Extract downloaded nodejs tar file in previous step. 
# Install to /usr/local
RUN tar --strip-components 1 -xzvf node-v* -C /usr/local

# Install following components using npm 
# - Yeoman 
# - Yeoman Hubot Generator 
RUN npm install -g yo generator-hubot

# Set the root password 
RUN echo "root:${ROOT_USER_PASSWORD}" | chpasswd 

# Create new user called define by DOCKER_USER environment variable 
# which will be able to work with yeoman. 
# Following issue prohibits using root with yo command 
# https://github.com/yeoman/yeoman.io/issues/282 
RUN useradd -s /bin/bash ${DOCKER_USER}

# Set the work directory to home dir of the docker_user
WORKDIR /home/${DOCKER_USER}

# Set the user id 
USER ${DOCKER_USER} 
RUN yo hubot --owner="<Bot Wrangler <bw@example.com>" --name="Hubot" \
    --description="Delightfully aware robutt" --adapter=slack --defaults

# Install the Slack adapter for Hubot
RUN npm install hubot-slack --save

# clean out the default scripts
RUN rm -r ./scripts/ && \
echo [ \"hubot-help\", \"hubot-redis-brain\" ] > external-scripts.json

# Start bot
CMD ./bin/hubot --adapter slack

############################################################################### #                                    End                                      # ###############################################################################
