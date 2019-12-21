class daily_programs::config {
	# Permissions for veracrypt.
	file { '/etc/sudoers.d/veracrypt':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/veracrypt/sudo_veracrypt',
	}
}
