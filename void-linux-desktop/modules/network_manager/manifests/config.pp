class network_manager::config {
	group { 'network':
		ensure   => 'present',
		provider => 'groupadd',
	}

	file { '/etc/NetworkManager/dispatcher.d/10-chrony.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0700',
		source => 'puppet:///modules/network_manager/10-chrony.sh',
	}

	file { '/etc/NetworkManager/dispatcher.d/99-wifi-auto-off.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0700',
		source => 'puppet:///modules/network_manager/99-wifi-auto-off.sh',
	}
}
