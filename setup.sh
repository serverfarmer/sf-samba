#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install



base=/opt/farm/ext/samba-server/templates/$OSVER

if [ ! -f $base/smb.conf.tpl ]; then
	echo "skipping samba setup, unsupported operating system version"
	exit 1
fi

/opt/farm/scripts/setup/role.sh samba
/opt/farm/scripts/setup/role.sh sf-php

/etc/init.d/samba stop
update-rc.d -f samba remove

if [ ! -f /etc/samba/smb.conf.tpl ]; then
	install_copy $base/smb.conf.tpl /etc/samba/smb.conf.tpl
fi

if [ ! -f /etc/local/.config/samba.php ]; then
	install_copy $base/samba.php.tpl /etc/local/.config/samba.php
fi

ln -sf /opt/farm/ext/samba-server/samba-refresh.php /usr/local/bin/samba-refresh
