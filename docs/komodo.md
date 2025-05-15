# Komodo

This repo sets up Systemd services for the Komodo backend in both rootless and rootful mode, represented in the UI by separate servers.

## Database

Komodo is running with the default database choice, MongoDB. This runs as a Quadlet[^1]

[^1]:
  [Quadlet](https://www.redhat.com/en/blog/quadlet-podman) is a way to define, manage and run a podman container as a systemd service.

```ini title="komodo-mongo.container"
--8<-- "system_files/etc/containers/systemd/komodo-mongo.container"
```

The `komodo-seed-config.service` is responsible for setting up the username and password by templating to the file `/etc/containers/systemd/komodo-mongo.container.d/override.conf`

```ini title="komodo-mongo.container.d/override.conf"
--8<-- "system_files/etc/systemd/komodo-mongo.override.conf"
```

## Periphery

Periphery is the server component of Komodo, this runs on each server you want to manage in your "fleet".

It can be set up in a couple of ways, directly as a container, or with the binary running straight on the host. I opted for the latter, as it becomes less cumbersome (in my head) to make it work with Podman.

=== "System"

    ```ini title="komodo-periphery.service" hl_lines="8-13"
    --8<-- "system_files/etc/systemd/system/komodo-periphery.service"
    ```

=== "User"

    ```ini title="komodo-periphery.service" hl_lines="6-11"
    --8<-- "system_files/etc/systemd/user/komodo-periphery.service"
    ```

Periphery is set up as two services, system and user. This is why the service file mixes both file and environment variable configuration, where the environment is set to handle the differences between the services, like the port, paths and podman socket location.

This is also set up to depend on `komodo-seed-config.service` to support potential further secrets in the config file.

## Core

The Core is the component that ties it all together, providing the UI as well as the logic. This also runs as a Quadlet.

```ini title="komodo-core.container"
--8<-- "system_files/etc/containers/systemd/komodo-core.container"
```

The same `komodo-seed-config.service` is set as a dependency, to template out the core config file, telling it about the database and other settings that you might hide.
