# Install Alsa.
class setup_desktop::alsa {
	void::package { 'alsa-utils':
		ensure => 'installed',
	}
	void::package { 'alsa-lib':
		ensure => 'installed',
	}

	void::service { 'alsa':
		enable => true,
		require => [
			Void::Package['alsa-utils'],
			Void::Package['alsa-lib'],
		]
	}
}
