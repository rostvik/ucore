#!/usr/bin/env bash
#
# Based on https://github.com/ublue-os/ucore/blob/main/ucore/system_files/usr/sbin/ucore-paths-provision.sh
# Pre-seed Komodo directories
#
#DIR_MODE;DIR_PATH;DIR_USER

read -r -d '' CONFIG << EOF
755;/opt/docker/komodo/
750;/opt/docker/komodo/periphery-user;1000:1000
750;/opt/docker/komodo/mongo;1000:1000
750;/opt/docker/komodo/periphery-root
EOF

for MODE_PATH in $CONFIG; do
    MP=(${MODE_PATH//;/ })
    if [ ! -d "${MP[1]}" ]; then
      mkdir -p -m ${MP[0]} ${MP[1]}
        if [ -z ${var+x} ]; then
          chown ${MP[2]} ${MP[1]}
        fi
      restorecon -v ${MP[1]}
    fi
done
