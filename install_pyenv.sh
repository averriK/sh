#!/bin/bash

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
    liblzma-dev python-openssl git

# Clone pyenv repository
curl https://pyenv.run | bash

# Add pyenv to PATH and initialize pyenv in your .bashrc
SHELL_CONFIG="$HOME/.bashrc"

# Append pyenv paths to the .bashrc
echo -e '\n# Pyenv Configuration' >> $SHELL_CONFIG
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $SHELL_CONFIG
echo 'eval "$(pyenv init --path)"' >> $SHELL_CONFIG
echo 'eval "$(pyenv init -)"' >> $SHELL_CONFIG
echo 'eval "$(pyenv virtualenv-init -)"' >> $SHELL_CONFIG

# Reload .bashrc to apply changes
source $SHELL_CONFIG

# Install the latest available versions for Python 3.9, 3.10, 3.11, 3.12
declare -a VERSIONS=("3.9" "3.10" "3.11" "3.12")

# Ensure pyenv is initialized
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Function to find the latest patch version
function install_latest_patch {
    local version_prefix="$1"
    local full_version=$(pyenv install --list | grep -E "^\s*$version_prefix" | tail -1 | tr -d ' ')
    if [[ -n "$full_version" ]]; then
        pyenv install -s "$full_version"
    else
        echo "Version $version_prefix not found or not available."
    fi
}

# Loop through each version prefix to find and install the latest version
for prefix in "${VERSIONS[@]}"; do
    install_latest_patch $prefix
done

# Set one of the installed versions as global default Python version
pyenv global "${VERSIONS[-1]}"

# Show the current Python version to verify the installation
python --version

echo "Pyenv installation and Python setup complete. Please restart your terminal."
