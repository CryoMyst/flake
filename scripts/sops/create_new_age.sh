#! /usr/bin/env -S nix-shell
#! nix-shell -i bash -p bash -p sops -p age

# This script runs age-keygen to a specific directory and encrypts it with the master sops key
# Parameters
KEY_DIRECOTRY=$1
KEY_NAME="sops.backup"

# Ensure directory is given
if [ -z "$KEY_DIRECOTRY" ]; then
    echo "Key directory not set"
    exit 1
fi

# Ensure file does not exist else exit
KEY_PATH="$KEY_DIRECOTRY/$KEY_NAME"
if [ -f "$KEY_PATH" ]; then
    echo "Key file already exists: $KEY_DIRECOTRY/$KEY_NAME, delete it first if this was intentional"
    exit 1
fi

KEY_OUTPUT=$(age-keygen)
PUBLIC_KEY=$(echo "$KEY_OUTPUT" | grep "public key" | awk '{print $4}')
PRIVATE_KEY=$(echo "$KEY_OUTPUT" | tail -n 1)

echo "New key created:"
echo "Public key: $PUBLIC_KEY"

echo "Writing the key to $KEY_PATH"
printf "%s" "$PRIVATE_KEY" > "$KEY_PATH"
echo "Encrypting the key"
sops --encrypt --in-place "$KEY_PATH"

# If the process failed remove the key
if [ $? -ne 0 ]; then
    echo "Failed to encrypt the key, removing it for security"
    rm "$KEY_PATH"
    exit 1
fi