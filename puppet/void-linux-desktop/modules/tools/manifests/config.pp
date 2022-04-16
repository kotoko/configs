class tools::config {
	file { '/usr/bin/gpg':
		ensure => 'link',
		target => '/usr/bin/gpg2',
		owner => 'root',
		group => 'root',
		mode => '0755',
		backup => false,
	}
}