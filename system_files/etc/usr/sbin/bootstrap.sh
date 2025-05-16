#!/usr/bin/env bash

set -e

EDITOR=vim

# Prompt for editing of service to set up 1password cli
sudo systemctl edit komodo-seed-config.service

# Enable and run the service responsible for seeding the config files
sudo systemctl enable --now komodo-seed-config.service

# Enable Podman services
sudo systemctl enable --now podman.socket
systemctl enable --now --user podman.socket

# Enable Komondo backend services
sudo systemctl enable komodo-periphery.service
systemctl enable --user komodo-periphery.service

# Enable and log in to Tailscale
sudo systemctl enable --now tailscaled.service
sudo tailscale login

# Reboot for services to take effect in order
sudo systemctl reboot
