class sysctl::config {
	$swappiness = '30'

	file { '/etc/sysctl.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		content => template('sysctl/sysctl.conf.erb'),
	}
}
