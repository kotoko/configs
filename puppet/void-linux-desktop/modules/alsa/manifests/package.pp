class alsa::package {
	void::package { 'alsa-utils':
		ensure => 'installed',
	}

	void::package { 'alsa-lib':
		ensure => 'installed',
	}
}
