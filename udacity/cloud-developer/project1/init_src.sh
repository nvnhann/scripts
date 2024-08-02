#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Installing Git..."
    # Update the package list
    sudo apt update
    # Install Git
    sudo apt install -y git
    echo "Git has been installed."
else
    echo "Git is already installed."
fi

git clone https://github.com/nvnhann/Deploy-Static-Website-on-AWS.git src

