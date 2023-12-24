class cron::config {
	file { '/etc/cron.d':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}
}
