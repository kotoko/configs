class polkit::config {
	file { '/etc/polkit-1':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	file { '/etc/polkit-1/rules.d':
		ensure => 'directory',
		backup => false,
		owner => 'polkitd',
		group => 'polkitd',
		mode => '0700',
	}

	File['/etc/polkit-1'] ->
	File['/etc/polkit-1/rules.d']
}