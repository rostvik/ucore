#!/usr/bin/env bash
#
# Pre-seed Komodo config files
#
#DESTINATION_MODE;TEMPLATE_DIR;DESTINATION_DIR

read -r -d '' CONFIG << EOF
0600;/etc/komodo/core.config.toml;/opt/docker/komodo/core.config.toml
0644;/etc/komodo/periphery.config.toml;/opt/docker/komodo/periphery.config.toml
0600;/etc/systemd/komodo-mongo.override.conf;/etc/containers/systemd/komodo-mongo.container.d/override.conf
EOF

for TEMPLATE_PATH in $CONFIG; do
    TP=(${TEMPLATE_PATH//;/ })
    TP_DIR=$(dirname "${TP[2]}")
    if [ ! -d "${TP_DIR}" ]; then
      mkdir -p "${TP_DIR}"
    fi
    if [ ! -f "${TP[2]}" ]; then
      echo "seeding ${TP[1]} into ${TP[2]}"
      op inject --file-mode "${TP[0]}" --in-file "${TP[1]}" --out-file "${TP[2]}"
    fi
done
