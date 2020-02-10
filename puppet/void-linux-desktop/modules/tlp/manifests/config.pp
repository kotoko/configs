class tlp::config {
	file { '/etc/default':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/default/tlp':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/tlp/tlp',
	}

	File['/etc/default'] ->
	File['/etc/default/tlp']
}
