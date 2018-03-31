<?php

$server_name = "SAMBA";

$always_access = "smb-admin";

$smb_shares = array (
//	share name                disk browsable local   read users                 +write
	"public"        => array( 1,   true,     true,   "smb-user1, smb-user2",    false ),
	"downloads"     => array( 2,   true,     true,   "smb-user3, smb-user4",    true ),
);

function get_path($disk)
{
	return array("/srv/mounts/internal$disk/samba", "internal$disk");
}
