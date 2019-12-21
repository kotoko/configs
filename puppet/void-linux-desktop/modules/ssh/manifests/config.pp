class ssh::config {
	file { '/etc/sshguard.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/ssh/sshguard.conf',
	}
}
