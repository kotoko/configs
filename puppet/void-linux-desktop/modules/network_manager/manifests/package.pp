class network_manager::package {
	void::package { 'NetworkManager':
		ensure => 'installed',
	}

	void::package { 'dnsmasq':
		ensure => 'installed',
	}
}
