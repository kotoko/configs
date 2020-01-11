class network_manager::service {
	void::sv { 'down dhcpd':
		command => 'down',
		service => 'dhcpd',
	}

	void::sv { 'down dhcpcd':
		command => 'down',
		service => 'dhcpcd',
	}

	void::service { 'dhcpd':
		enable => false,
	}

	void::service { 'dhcpcd':
		enable => false,
	}

	void::sv { 'up NetworkManager':
		command => 'up',
		service => 'NetworkManager',
	}

	void::service { 'NetworkManager':
		enable => true,
	}

	Void::Sv['down dhcpd'] ->
	Void::Service['dhcpd'] ->
	Void::Sv['down dhcpcd'] ->
	Void::Service['dhcpcd'] ->
	Void::Sv['up NetworkManager'] ->
	Void::Service['NetworkManager']
}
