class firewall::package {
	void::package { 'iptables':
		ensure => 'installed',
	}

	void::package { 'ipset':
		ensure => 'installed',
	}
}
