class alsa::package {
	void::package { 'alsa-utils':
		ensure => 'installed',
	}

	void::package { 'alsa-lib':
		ensure => 'installed',
	}

	void::package { 'sof-firmware':
		ensure => 'installed',
	}
}
