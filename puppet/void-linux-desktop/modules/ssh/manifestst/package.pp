class ssh::package {
	void::package { 'openssh':
		ensure => 'installed',
	}

	void::package { 'sshguard':
		ensure => 'installed',
	}
}
