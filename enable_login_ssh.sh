#!/bin/bash

# This script enables password authentication for SSH, restarts the SSH service,
# and ensures that the firewall allows SSH connections.

# Function to print a message with a timestamp
log() {
    echo "$(date +"%Y-%m-%d %T") - $1"
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    log "Please run this script as root or with sudo."
    exit 1
fi

# Enable password authentication in SSH configuration
log "Enabling password authentication in SSH configuration..."
SSH_CONFIG="/etc/ssh/sshd_config"
if grep -q "^#PasswordAuthentication no" "$SSH_CONFIG"; then
    sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' "$SSH_CONFIG"
elif grep -q "^PasswordAuthentication no" "$SSH_CONFIG"; then
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' "$SSH_CONFIG"
elif ! grep -q "^PasswordAuthentication yes" "$SSH_CONFIG"; then
    echo "PasswordAuthentication yes" >> "$SSH_CONFIG"
fi

# Disable challenge-response authentication
log "Disabling challenge-response authentication..."
if grep -q "^#ChallengeResponseAuthentication yes" "$SSH_CONFIG"; then
    sed -i 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' "$SSH_CONFIG"
elif grep -q "^ChallengeResponseAuthentication yes" "$SSH_CONFIG"; then
    sed -i 's/^ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' "$SSH_CONFIG"
elif ! grep -q "^ChallengeResponseAuthentication no" "$SSH_CONFIG"; then
    echo "ChallengeResponseAuthentication no" >> "$SSH_CONFIG"
fi

# Restart the SSH service
log "Restarting the SSH service..."
systemctl restart sshd

# Ensure firewall allows SSH connections
log "Allowing SSH connections through the firewall..."
if command -v ufw &> /dev/null; then
    ufw allow ssh
    ufw reload
elif command -v firewall-cmd &> /dev/null; then
    firewall-cmd --permanent --add-service=ssh
    firewall-cmd --reload
else
    log "No supported firewall management tool found. Please ensure SSH is allowed manually."
fi

log "SSH password authentication has been enabled and the firewall has been configured."

# Verify SSH daemon status
log "Verifying SSH daemon status..."
systemctl status sshd --no-pager

log "Script completed."
