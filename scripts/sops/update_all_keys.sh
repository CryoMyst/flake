#! /usr/bin/env -S nix-shell
#! nix-shell -i bash -p bash -p sops -p yq -p git

# This script updates all files matching the creation_rules in the sops.yaml file
# This needs to be done manually for now https://github.com/getsops/sops/issues/1071
SOPS_YAML_FILE=${1:-".sops.yaml"}

# Find all path_regex in the sops.yaml file
CREATION_RULES=$(yq -r '.creation_rules[] | .path_regex' "$SOPS_YAML_FILE") 
echo "Found creation rules:"
echo "$CREATION_RULES"

for RULE in $CREATION_RULES; do
    echo "Updating files matching $RULE"
    FILES=$(git ls-files | grep -E "$RULE")
    for FILE in $FILES; do
        echo "Updating $FILE"
        sops updatekeys "$FILE"
    done
done

echo "All files updated"