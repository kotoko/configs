class network_manager::config {
	# Allow users to manage connections.
	file { '/etc/polkit-1/rules.d/50-org.freedesktop.NetworkManager.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/network_manager/50-org.freedesktop.NetworkManager.rules',
	}
}
