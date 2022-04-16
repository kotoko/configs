class tlp::config {
	file { '/etc/tlp.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/tlp/tlp.conf',
	}
}
