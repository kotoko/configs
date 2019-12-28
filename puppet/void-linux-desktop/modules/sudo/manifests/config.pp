class sudo::config {
	file { '/etc/sudoers.d':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}
}