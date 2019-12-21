class xorg::package {
	void::package { 'xorg':
		ensure => 'installed',
	}
}
