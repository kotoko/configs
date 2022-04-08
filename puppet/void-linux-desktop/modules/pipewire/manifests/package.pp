class pipewire::package {
  void::package { 'pipewire':
		ensure => 'installed',
	}

	# ALSA integration
	void::package { 'alsa-pipewire':
		ensure => 'installed',
	}

	# Pulseaudio replacement
	void::package { 'pulseaudio-utils':
		ensure => 'installed',
	}

	# Bluetooth
	void::package { 'libspa-bluetooth':
		ensure => 'installed',
	}

	# JACK replacement
	void::package { 'libjack-pipewire':
		ensure => 'installed',
	}
}
