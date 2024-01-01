class bluetooth::package {
	void::package { 'bluez':
		ensure => 'installed',
	}
}
