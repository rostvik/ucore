# Bootstraping the box

## Enroll uBlue Secure Boot key

To use TPM based LUKS, we need to get secure boot going

```
sudo mokutil --import /etc/pki/akmods/certs/akmods-ublue.der
```

The ZFS module is signed with uBlues key.

After the the cert is imported, reboot the machine, and select to add the MOK in the blue screen popping up.

As this is using the shim, the Microsoft SB keys can now be used.

## Running uCore

To prime the secrets needed, and start the required services, a convenience script is created at `/etc/usr/sbin/bootstrap.sh`

```shell title="bootstrap.sh"
--8<-- "system_files/etc/usr/sbin/bootstrap.sh"
```
