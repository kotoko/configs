class network_manager::config {
	# Allow users to manage connections.
	file { '/etc/polkit-1/rules.d/51-org.freedesktop.NetworkManager.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/network_manager/51-org.freedesktop.NetworkManager.rules',
	}

	group { 'network':
		ensure   => 'present',
		provider => 'groupadd',
	}

	File['/etc/polkit-1/rules.d'] ->
	File['/etc/polkit-1/rules.d/51-org.freedesktop.NetworkManager.rules']
}
