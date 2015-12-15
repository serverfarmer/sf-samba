#!/usr/bin/php
<?php
// Samba configuration generator
// Tomasz Klim, April 2011


require_once "/etc/local/.config/samba.php";

$text = "";
foreach ( $smb_shares as $name => $config )
{
	list($path, $comment) = get_path($config[0]);

	if ( file_exists($path) ) {
		$fullpath = "$path/$name";

		if ( !file_exists($fullpath) ) {
			$text .= "# share $name directory not exists\n\n";
			continue;
		}

		$browsable = $config[1] ? "yes" : "no";
		$local = $config[2];
		$read_users = $config[3];
		$write = $config[4];

		if ( !$local ) {
			$file_mask = "0600";
			$dir_mask  = "0700";
			$valid_users = ( $read_users ? "$always_access, $read_users" : $always_access );
			$write_list = false;
			$read_only = "yes";

		} else if ( $read_users && $write ) {
			$file_mask = "0660";
			$dir_mask  = "0770";
			$valid_users = "$always_access, $read_users";
			$write_list = false;
			$read_only = "no";

		} else if ( $read_users ) {  // !$write
			$file_mask = "0640";
			$dir_mask  = "0750";
			$valid_users = "$always_access, $read_users";
			$write_list = $always_access;
			$read_only = "yes";

		} else {  // empty($read_users)
			$file_mask = "0600";
			$dir_mask  = "0700";
			$valid_users = $always_access;
			$write_list = false;
			$read_only = "no";
		}

		$text .= "[$name]\n";
		$text .= "   comment = $comment: $name\n";
		$text .= "   path = $fullpath\n";
		$text .= "   browseable = $browsable\n";
		$text .= "   read only = $read_only\n";
		$text .= "   create mask = $file_mask\n";
		$text .= "   directory mask = $dir_mask\n";
		$text .= "   valid users = $valid_users\n";
		if ( $write_list )
		$text .= "   write list = $write_list\n";
		$text .= "\n";
	}
}

$template = file_get_contents( "/etc/samba/smb.conf.tpl" );
$config = str_replace( "@@shares@@", $text, $template );
$config = str_replace( "@@server@@", $server_name, $config );
file_put_contents( "/etc/samba/smb.conf", $config );
