class setup_desktop::ssh {
	void::package { 'openssh':
		ensure => 'installed',
	}

	# Disable openssh daemon by default.
	void::service { 'openssh':
		enable => false,
		require => Void::Package['openssh'],
	}

	void::package { 'sshguard':
		ensure => 'installed',
	}

	void::service { 'sshguard-socklog':
		enable => true,
		require => [
			Void::Package['sshguard'],
			Void::Package['socklog-void'],
			File['/etc/sshguard.conf'],
		],
	}

	file { '/etc/sshguard.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/ssh/sshguard.conf',
		require => Void::Package['sshguard'],
	}
}
