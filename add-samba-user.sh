#!/bin/bash
. /opt/farm/scripts/functions.uid
. /opt/farm/scripts/functions.custom
# create Samba account, first on local server (just to reserve UID),
# then on specified Samba server (or only on local Samba server)
# Tomasz Klim, 2015


MINUID=1600
MAXUID=1799


if [ "$1" = "" ]; then
	echo "usage: $0 <user> [remote-server]"
	exit 1
elif ! [[ $1 =~ ^[a-z0-9]+$ ]]; then
	echo "error: parameter 1 not conforming user name format"
	exit 1
elif [ -d /home/smb-$1 ]; then
	echo "error: user $1 exists"
	exit 1
fi

uid=`get_free_uid $MINUID $MAXUID`

if [ $uid -lt 0 ]; then
	echo "error: no free UIDs"
	exit 1
fi

if [ "$2" != "" ]; then
	if ! [[ $2 =~ ^[-.a-z0-9]+$ ]]; then
		echo "error: parameter 2 not conforming host name format"
		exit 1
	elif [ "`getent hosts $2`" = "" ]; then
		echo "error: host $2 not found"
		exit 1
	fi
fi

path=/home/smb-$1

useradd -u $uid -d $path -m -g sambashare -s /bin/false smb-$1
chmod 0711 $path
rm $path/.bash_logout $path/.bashrc $path/.profile

if [ "$2" = "" ]; then
	smbpasswd -a smb-$1
else
	server=$2
	sshkey=`ssh_management_key_storage_filename $server`

	ssh -i $sshkey root@$server "useradd -u $uid -d $path -m -g sambashare -s /bin/false smb-$1"
	ssh -i $sshkey root@$server "chmod 0711 $path"
	ssh -i $sshkey root@$server "rm $path/.bash_logout $path/.bashrc $path/.profile"
	ssh -i $sshkey root@$server "smbpasswd -a smb-$1"
fi
