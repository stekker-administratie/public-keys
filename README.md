# public-keys
Repository to manage the public keys of authorized employees. These keys will be synced to the different VPS's so the access is easily managed.

## Quick Installation
To interactively generate your key and configure your agent, you can run the installation script directly from GitHub:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/stekker-administratie/public-keys/main/install.sh)
```
> **Note**: Since the script is interactive, we use `bash <(...)` to ensure it can read your input from the terminal.

## Creating ssh key
Run the following command for creating your ssh key pair. Fill in a strong password.
```
ssh-keygen -t ed25519 -C "name@leblo.nl"
```
After the key pair is created store your password with key pair somewhere safe, for example in LastPass.
Add the following to your ~/.bashrc file so that an agent is started when you startup your system.
```
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
```

> [!CAUTION]
> Do not us a key whithout a password.

## Guidelines and requirements
- The authorized_key file is in alphabetical order.
- Comments ALWAYS refer to a person or/and device.
- A password needs at least 12 characters
- A password needs at least 1 uppercase character, lowercase character, number and a symbol