sf-samba-server extension provides managed Samba solution for small and medium
companies. It is compatible with the following operating systems:

- Debian 6.x (Squeeze)
- Debian 7.x (Wheezy)
- Debian 8.x (Jessie)
- Debian 9.x (Stretch)
- Debian 10.x (Buster)
- Ubuntu 16.04 LTS (Xenial Xerus)
- Ubuntu 20.04 LTS (Focal Fossa)

Shares configuration are stored in /etc/local/.config/samba.php file. Script
samba-refresh.php generates Samba configuration base on this file, while
add-samba-user.sh allows adding new users.


### Configuring samba for full disk encryption server

#### Pre-systemd Debian/Ubuntu/clones

```
/etc/init.d/samba stop
update-rc.d -f samba remove
```
