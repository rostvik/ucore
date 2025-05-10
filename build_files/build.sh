#!/bin/bash

set -ouex pipefail

dnf5 install -y tree

# rm /usr/etc/containers/policy.json /etc/containers/policy.json
# rmdir /usr/etc{/containers,}
