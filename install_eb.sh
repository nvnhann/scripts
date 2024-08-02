
#!/bin/bash

# Update your package list and install any available upgrades
sudo apt-get update
sudo apt-get upgrade -y

# Install required packages, including Python and pip
sudo apt-get install -y python3 python3-pip python3-virtualenv
# Add .local/bin to PATH for Bash
if [ -n "$BASH_VERSION" ]; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
fi

# Add .local/bin to PATH for Zsh
if [ -n "$ZSH_VERSION" ]; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
    source ~/.zshrc
fi

# Verify virtualenv installation
if ! command -v virtualenv &> /dev/null; then
    echo "virtualenv could not be found, please check the installation steps."
    exit 1
fi

# Clone the AWS Elastic Beanstalk CLI setup repository
git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git

# Run the EB CLI installer script
python3 ./aws-elastic-beanstalk-cli-setup/scripts/ebcli_installer.py

# Clean up the cloned repository
rm -rf aws-elastic-beanstalk-cli-setup

# Verify the EB CLI installation
if ! command -v eb &> /dev/null; then
    echo "EB CLI installation failed or EB CLI is not in PATH."
    exit 1
else
    eb --version
fi
