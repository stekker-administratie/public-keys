#!/bin/bash

# Interactive setup script based on README.md

set -e

echo "Welcome to the interactive public-keys setup script."

# Step 1: Create SSH key
echo "----------------------------------------------------------------"
echo "Step 1: Creating SSH key"
echo "----------------------------------------------------------------"
read -p "Enter your email address and/or a device name: " email

if [ -z "$email" ]; then
    echo "Email is required. Exiting."
    exit 1
fi

echo "Generating SSH key for $email..."
echo "IMPORTANT: You will be asked to enter a passphrase."
echo "  - At least 12 characters"
echo "  - At least 1 uppercase, 1 lowercase, 1 number, and 1 symbol"
echo ""

ssh-keygen -t ed25519 -C "$email"

# Step 2: Update .bashrc
echo ""
echo "----------------------------------------------------------------"
echo "Step 2: Configuring ssh-agent in ~/.bashrc"
echo "----------------------------------------------------------------"
echo "This will add a script to start ssh-agent automatically and add your key when you open a terminal."

read -p "Do you want to add the ssh-agent configuration to ~/.bashrc? (y/n): " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    BASHRC="$HOME/.bashrc"
    
    # Simple check to see if we might have already added it or something similar
    if grep -q "AGENT_ENV=\"\$HOME/.ssh/agent.env\"" "$BASHRC"; then
        echo "It looks like the ssh-agent configuration is already present in $BASHRC. Skipping."
    else
        cat << 'EOF' >> "$BASHRC"

# Start ssh-agent if not already running
if [ -z "$SSH_AUTH_SOCK" ]; then
    AGENT_ENV="$HOME/.ssh/agent.env"

    if [ -f "$AGENT_ENV" ]; then
        source "$AGENT_ENV" >/dev/null
    fi

    if ! ssh-add -l >/dev/null 2>&1; then
        eval "$(ssh-agent -s)" >/dev/null
        ssh-add ~/.ssh/id_ed25519
        echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$AGENT_ENV"
        echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$AGENT_ENV"
        chmod 600 "$AGENT_ENV"
    fi
fi
EOF
        echo "Success: Configuration appended to $BASHRC."
        echo "Run 'source ~/.bashrc' or restart your terminal to apply the changes."
    fi
else
    echo "Skipping .bashrc update."
fi

echo ""
echo "Setup complete."
