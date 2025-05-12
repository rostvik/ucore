#!/bin/bash

set -ouex pipefail

dnf5 install -y podman-compose


systemctl enable komodo-paths-provision.service
