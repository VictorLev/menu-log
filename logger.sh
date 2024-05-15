#!/bin/bash

# Define a global variable for the specific user
USER_TO_ALLOW="vlevesque"

# Function to check if the current user matches the allowed user
function check_user {
  if [[ "$(whoami)" != "$USER_TO_ALLOW" ]]; then
    printf "This command is allowed for %s only.\n" "$USER_TO_ALLOW" >&2
    return 1
  fi
}

# Main function where your custom command functionality would be placed
function main {
  check_user || return 1
  # Add the command's functionality below this line
  printf "Running command for user: %s\n" "$(whoami)"
}

# Place the script in a location within your home directory
script_path="$HOME/bin/log"

# Create the directory if it does not exist
mkdir -p "$(dirname "$script_path")"

# Write the script to a file
cat << EOF > "$script_path"
$(declare -f check_user)
$(declare -f main)
main "\$@"
EOF

# Make the script executable
chmod +x "$script_path"

# Add the script directory to your PATH if not already present
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  echo 'export PATH="$PATH:$HOME/bin"' >> "$HOME/.bashrc"
  # Reload .bashrc to apply changes immediately
  source "$HOME/.bashrc"
fi

# Now you can run your script as 'custom_command' from anywhere in your user session