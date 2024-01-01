class sudo::package {
	void::package { 'sudo':
		ensure => 'installed',
	}
}