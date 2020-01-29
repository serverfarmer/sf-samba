#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install



base=/opt/farm/ext/samba-server/templates/$OSVER

if [ ! -f $base/smb.conf.tpl ]; then
	echo "skipping samba setup, unsupported operating system version"
	exit 1
fi

/opt/farm/ext/farm-roles/install.sh samba
/opt/farm/scripts/setup/extension.sh sf-php

if [ ! -f /etc/samba/smb.conf.tpl ]; then
	install_copy $base/smb.conf.tpl /etc/samba/smb.conf.tpl
fi

if [ ! -f /etc/local/.config/samba.php ]; then
	install_copy $base/samba.php.tpl /etc/local/.config/samba.php
fi
