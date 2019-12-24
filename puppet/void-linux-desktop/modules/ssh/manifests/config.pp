class ssh::config {
	file { '/etc/sshguard.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/ssh/sshguard.conf',
	}

	file { '/etc/ssh/sshd_config':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/ssh/sshd_config',
	}

	group { 'ssh_users':
		ensure   => 'present',
		provider => 'groupadd',
	}
}
