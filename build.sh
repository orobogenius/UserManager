#!/bin/bash

# Install docker if it hasn't been installed
install_docker() {
    which docker

    if [[ $? -eq 0 ]]; then
        echo "Docker is already installed, skipping..."
    else
        echo "Installing docker..."
        sudo apt-get update
        sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        # Verify that fingerprint matches
        sudo apt-key fingerprint 0EBFCD88 | grep 0EBFCD88 > /dev/null

        if [[ $? -eq 0 ]]; then
            echo "Fingerprint matched, continuing installation..."
            
            sudo add-apt-repository \
                "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) \
                stable"
            
            sudo apt-get update
            sudo apt-get install docker-ce

            # Confirm that docker has been installed
            sudo docker run hello-world > /dev/null 2>&1

            if [[ $? -eq 0 ]]; then
                echo "Docker installed."
            else
                echo "Docker not installed."
            fi

            return 0
        else
            # Terminate script if there's a fingerprint mismatch
            tput setaf 1; echo "Invalid fingerprint, installation terminated, please try running the script again."
            exit -1
        fi
    fi
}

# Install docker-compose if it hasn't already been installed
install_docker_compose() {
    sudo docker-compose --version > /dev/null 2>&1
    
    if [[ $? -eq 0 ]]; then
        echo "docker-compose already installed, skipping..."
    else
        echo "Installing docker-compose..."

        sudo curl -L \
        https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` \
        -o /usr/local/bin/docker-compose

        sudo chmod +x /usr/local/bin/docker-compose

        sudo docker-compose --version > /dev/null

        if [[ $? -eq 0 ]]; then
            echo "docker-compose installed"
        else
            # Terminate script if docker-composer isn't installed
            tput setaf 1; echo "docker-compose not installed"
            exit -1
        fi

        return 0
    fi
}

# Prepare and build the containers and deploy app
build_containers() {
    echo "Building containers and deploying app..."
    cp .env-sample .env
    docker-compose up -d --build
    echo "App deployed, visit http://localhost:3000/users"
}

init() {
    install_docker
    install_docker_compose
    build_containers
}

# Run build
init