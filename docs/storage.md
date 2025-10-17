# Storage


## ZFS Pool

<!-- https://github.com/quietsy/advanced-configurations/blob/ffdbb1f8dc5c13871a007122a520fd107898fb0c/docs/Other/zfs.md -->

The target machine has 2 NVME drives intended to serve a mirror.

Find disks:

```shell
sudo lsblk -o NAME,SIZE,SERIAL,LABEL,FSTYPE
```

Create pool:

```shell
sudo zpool create \
  -o ashift=12 \  # (1)
  -O aclinherit=passthrough \
  -O acltype=posix \
  -O atime=off \ # (2)
  -O compression=lz4 \
  -O xattr=sa \ # (3)
  -m none \ # (4)
  tank \ # (5)
  mirror \
  /dev/disk/by-id/nvme-KINGSTON_SFYRD2000G_50026B768694E467 \
  /dev/disk/by-id/nvme-KINGSTON_SFYRD2000G_50026B768694EB03
```

1. Disk offers 4k sectors, same as [here](https://www.reddit.com/r/zfs/comments/1lz7qud/nvmes_that_support_512_and_4096_at_format_time/)
2. Updates the access time on read, not useful data, set to false to prevent those writes.
3. This machine has SELinux enabled, and setting this to `sa` is therefore recommended.
4. Mounting the pool itself isn't desired with the dataset layout, those will be mounted later.
5. Name of the pool

Create datasets:

```shell
sudo zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///run/zfs-hex -o mountpoint=/mnt/spicy tank/spicy
```
