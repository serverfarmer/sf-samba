#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install



base=/opt/sf-samba/templates/$OSVER

if [ ! -f $base/smb.conf.tpl ]; then
	echo "skipping samba setup, unsupported operating system version"
	exit 1
fi

bash /opt/farm/scripts/setup/role.sh samba
bash /opt/farm/scripts/setup/role.sh sf-php

/etc/init.d/samba stop
update-rc.d -f samba remove

if [ ! -f /etc/samba/smb.conf.tpl ]; then
	install_copy $base/smb.conf.tpl /etc/samba/smb.conf.tpl
fi

if [ ! -f /etc/local/.config/samba.php ]; then
	install_copy $base/samba.php.tpl /etc/local/.config/samba.php
fi

ln -sf /opt/sf-samba/add-samba-user.sh /usr/local/bin/add-samba-user
ln -sf /opt/sf-samba/samba-refresh.php /usr/local/bin/samba-refresh
