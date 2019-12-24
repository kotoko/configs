class backup::config {
	file { '/etc/sudoers.d/backup':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/backup/sudo_backup',
	}

	# Hide user from login screen.
	exec { 'backup_user_sddm_config':
		command => '/sbin/sed -i -e "s/^\(HideUsers=\).*$/\1backup/" /etc/sddm.conf',
	}
}