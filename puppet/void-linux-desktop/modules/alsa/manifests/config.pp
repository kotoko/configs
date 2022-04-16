class alsa::config {
	group { 'audio':
		ensure   => 'present',
		provider => 'groupadd',
	}

	file { '/etc/alsa':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	file { '/etc/alsa/conf.d':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	File['/etc/alsa'] ->
	File['/etc/alsa/conf.d']
}