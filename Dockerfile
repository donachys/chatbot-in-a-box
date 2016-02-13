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
# wget is required to download python and npm tar files 
# build-essential is required for npm 
# Others are required for building python 2.7.11 
RUN yum update -y && yum install -y wget build-essential make
RUN yum install -y gcc gcc-c++
# RUN yum install -y libreadline-gplv2-dev libncursesw5-dev
# RUN yum install -y libssl-dev libsqlite3-dev tk-dev 
# RUN yum install -y libgdbm-dev libc6-dev libbz2-dev 

# Set the current work directory to /tmp directory 
WORKDIR ${TMP_DIR} 

# Download python 2.7.11 tar. 
# It will be downloaded to temp directory which is current work directory 
# RUN wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz

# Extract downloaded python tar file in previous step.
# It will be extracted to Python-2.7.11 directory which is inside /tmp directory
# RUN tar -xf Python-2.7.11.tgz

# To build python, change the current working directory to directory where 
# python source code is extracted. 
# WORKDIR ${TMP_DIR}/Python-2.7.11/

# Build python 2.7.5 source code and install it 
# RUN ./configure 
# RUN make 
# RUN make install 

# Change the current work directory back to /tmp directory 
WORKDIR ${TMP_DIR} 

# Download nodejs 5.6.0 tar. 
# It will be downloaded to temp directory which is current work directory 
RUN wget https://github.com/nodejs/node/archive/v5.6.0.tar.gz

# Extract downloaded nodejs tar file in previous step. 
# It will be extracted to node-5.6.0 directory which is inside /tmp directory 
RUN tar -xf v5.6.0.tar.gz

# To build nodejs, change the current working directory to directory where 
# nodejs source code is extracted. 
WORKDIR ${TMP_DIR}/node-5.6.0/ 

# Build nodejs 5.6.0 source code and install it 
RUN ./configure 
RUN make 
RUN make install 

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

# Add user defined by DOCKER_USER environment variable to the sudoers list 
# RUN useradd ${DOCKER_USER} sudo

# Set the work directory to home dir of the root
WORKDIR /home/${DOCKER_USER}

# Set the user id 
USER ${DOCKER_USER} 
# Start bash 
#CMD ["/bin/bash"] 
RUN yo hubot --owner="<Bot Wrangler <bw@example.com>" --name="Hubot" \
    --description="Delightfully aware robutt" --adapter=slack --defaults

############################################################################### #                                    End                                      # ###############################################################################