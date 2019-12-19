class setup_desktop::preload {
	void::package { 'preload':
		ensure => 'installed',
	}

	void::service { 'preload':
		enable => true,
		require => Void::Package['preload'],
	}
}
