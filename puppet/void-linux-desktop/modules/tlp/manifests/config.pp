class tlp::config {
	file { '/etc/tlp.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/tlp/tlp.conf',
	}

	File['/etc/tlp.conf']
}
