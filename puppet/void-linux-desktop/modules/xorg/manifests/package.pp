class xorg::package {
	void::package { 'xorg':
		ensure => 'installed',
	}

	void::package { 'xf86-input-mtrack':
		ensure => 'installed',
	}

	void::package { 'libinput-gestures':
		ensure => 'installed',
	}
}
