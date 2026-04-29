#!/bin/bash

# 1. Download the installer
echo "Downloading Reemo installer..."
curl -skL -o /tmp/install_reemo.x 'https://download.reemo.io/macos/setup.x'

# 2. Run the installer with sudo
# We use 'echo' to pipe the key into the installer when it prompts for input
echo "Starting installation and applying license key..."
echo "studio_ed083152d339" | sudo bash /tmp/install_reemo.x

echo "Installation process triggered."
