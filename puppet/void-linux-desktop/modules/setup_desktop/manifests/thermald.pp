class setup_desktop::thermald {
	void::package { 'thermald':
		ensure => 'installed',
	}

	void::service { 'thermald':
		enable => true,
		require => Void::Package['thermald'],
	}
}
