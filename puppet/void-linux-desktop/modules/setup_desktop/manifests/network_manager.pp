# Install NetworkManager.
class setup_desktop::network_manager {
	# Install NetworkManager.
	void::package { 'NetworkManager':
		ensure => 'installed',
	}

	# Disable dhcpd.
	void::sv { 'down dhcpd':
		command => 'down',
		service => 'dhcpd',
		require => Void::Package['NetworkManager'],
	}
	tidy { '/var/service/dhcpd':
		require => [
			Void::Sv['down dhcpd'],
			Void::Package['NetworkManager'],
		],
	}

	# Start NetworkManager.
	void::sv { 'up NetworkManager':
		command => 'up',
		service => 'NetworkManager',
		require => [
			Void::Package['NetworkManager'],
			Tidy['/var/service/dhcpd'],
			Void::Sv['down dhcpd'],
		],
	}

	# Add to autostart.
	void::service { 'NetworkManager':
		require => [
			Void::Package['NetworkManager'],
			Void::Sv['up NetworkManager'],
		]
	}

	# Allow users to manage connections.
	file { '/etc/polkit-1/rules.d/50-org.freedesktop.NetworkManager.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/network_manager/50-org.freedesktop.NetworkManager.rules',
		require => [
			Void::Package['NetworkManager'],
			Void::Package['polkit'],
		],
	}
}
