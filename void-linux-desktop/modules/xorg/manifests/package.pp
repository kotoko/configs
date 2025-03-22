class xorg::package {
	void::package { 'xorg-minimal':
		ensure => 'installed',
	}

	void::package { 'xorg-fonts':
		ensure => 'installed',
	}

	void::package { 'xorg-apps':
		ensure => 'installed',
	}

	void::package { 'xorg-video-drivers':
		ensure => 'installed',
	}

	void::package { 'xf86-input-mtrack':
		ensure => 'installed',
	}

	void::package { 'xf86-input-evdev':
		ensure => 'installed',
	}

	void::package { 'xf86-input-libinput':
		ensure => 'installed',
	}

	void::package { 'libinput-gestures':
		ensure => 'installed',
	}

	void::package { 'xf86-input-wacom':
		ensure => 'installed',
	}

}
