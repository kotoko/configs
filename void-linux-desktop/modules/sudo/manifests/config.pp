class sudo::config {
	file { '/etc/sudoers.d':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}
}