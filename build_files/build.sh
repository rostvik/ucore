#!/bin/env bash

set -ouex pipefail

dnf5 install -y \
  1password-cli \
  vim


systemctl enable komodo-paths-provision.service
