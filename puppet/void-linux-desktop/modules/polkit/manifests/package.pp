class polkit::package {
	void::package { 'polkit':
		ensure => 'installed',
	}
}