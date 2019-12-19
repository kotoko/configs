class setup_desktop::polkit {
	void::package { 'polkit':
		ensure => 'installed',
	}
}
