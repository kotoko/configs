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

	file { '/etc/sv/sshguard':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/sv/sshguard/run':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/ssh/sshguard_runit',
	}

	File['/etc/sv/sshguard'] ->
	File['/etc/sv/sshguard/run']
}
