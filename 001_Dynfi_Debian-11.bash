#!/bin/bash

# Variables for Java and MongoDB installation
java_link="https://download.java.net/java/GA/jdk11/28/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz"
dynfi_key="http://archive.dynfi.com/dynfi.gpg"
dynfi_repo="http://archive.dynfi.com/debian $(lsb_release -cs) main"
mongodb_key="https://www.mongodb.org/static/pgp/server-7.0.asc"
mongodb_repo="http://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/7.0 main"

# Function to display messages with color and delay

# Variable pour la couleur des messages
color="\033[1;34m"  # Bleu clair
reset_color="\033[0m"  # Réinitialisation de la couleur

show_message() {
    echo -e "${color}$1${reset_color}"
    sleep 1.5
}

# Update package lists and upgrade
upgrade_pkg() {
    show_message "Upgrade packages..."
	sudo apt update -y
	sudo apt upgrade -y
}

# Install necessary packages
necessary_pkg() {
    show_message "Install necessary packages..."
	sudo apt install -y -qq openssh-server tree gnupg curl wget
}

# Function to install Java 11
install_java() {
    show_message "Installing Java 11..."
    sudo apt install -y default-jdk 

    if [ $? -ne 0 ]; then
        show_message "Failed to install Java 11. Exiting."
        exit 1
    fi
    show_message "Java 11 installed successfully."
}

# Function to install Dynfi Manager
install_dynfi() {
    show_message "Installing Dynfi Manager..."
    wget -q -O - $dynfi_key | sudo apt-key add -
    echo "deb $dynfi_repo" | sudo tee /etc/apt/sources.list.d/dynfi.list
    sudo apt update
    sudo apt-get install -y dynfi
	
	show_message "Start dynfi.service..."
	sudo systemctl start dynfi.service
	show_message "Reload local package database..."
	sudo systemctl daemon-reload
	show_message "# Verify Dynfi status..."
    sudo systemctl status dynfi.service
	
	if [ $? -ne 0 ]; then
        show_message "Failed to install Dynfi Manager. Exiting."
        exit 1
    fi
    show_message "Dynfi Manager installed successfully."
}

# Function to install MongoDB
install_mongodb() {
    show_message "Installing MongoDB..."
    curl -fsSL $mongodb_key | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
    echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] $mongodb_repo" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    sudo apt update
    sudo apt-get install -y mongodb-org

    # Pin MongoDB package versions
    echo "mongodb-org hold" | sudo dpkg --set-selections
    echo "mongodb-org-database hold" | sudo dpkg --set-selections
    echo "mongodb-org-server hold" | sudo dpkg --set-selections
    echo "mongodb-mongosh hold" | sudo dpkg --set-selections
    echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
    echo "mongodb-org-tools hold" | sudo dpkg --set-selections

	show_message "Start MongoDB..."
    sudo systemctl start mongod
	show_message "Reload local package database..."	
	sudo systemctl daemon-reload
	show_message "# Verify MongoDB status..."	
    sudo systemctl status mongod

    if [ $? -ne 0 ]; then
        show_message "Failed to install MongoDB. Exiting."
        exit 1
    fi
    show_message "MongoDB installed successfully."
}

# Function Info 
info() {
	echo "---------------------------------------------------------------"
	show_message "Java 11, MongoDB and Dynfi Manager installation completed successfully!"
    echo "---------------------------------------------------------------"
    show_message "Please make sure to adjust any configurations as needed:"
	show_message "Dynfi = /etc/dynfi.conf"
	show_message "Dynfi = /etc/mongod.conf"
	echo "---------------------------------------------------------------"
    show_message "Open your preferred web browser on your local computer."
    show_message "Navigate to the URL: [ip]:9090"
    echo "-----------------------------------------------------------"
}

# Main script
main() {
	upgrade_pkg
	necessary_pkg
    install_java
	install_dynfi
    install_mongodb
	info
}

# Execute the main script
main

  
  
  
  