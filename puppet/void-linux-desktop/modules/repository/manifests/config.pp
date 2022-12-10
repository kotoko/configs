class repository::config {
	file { '/etc/xbps.d/00-repository-main.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/repository/00-repository-main.conf',
	}

	file { '/etc/xbps.d/10-repository-nonfree.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/repository/10-repository-nonfree.conf',
	}
}
