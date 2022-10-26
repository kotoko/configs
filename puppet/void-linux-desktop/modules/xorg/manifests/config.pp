class xorg::config {
	group { 'video':
		ensure   => 'present',
		provider => 'groupadd',
	}

	file { '/etc/X11':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	file { '/etc/X11/xorg.conf.d':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	File['/etc/X11'] ->
	File['/etc/X11/xorg.conf.d']
}
