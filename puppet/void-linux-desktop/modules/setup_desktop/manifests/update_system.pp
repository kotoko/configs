# Update system.
class setup_desktop::update_system {
	# Run multiple times just for sure. Sometimes xbps
	# wants to be updated and then only xbps updates.
	# For updating whole system another pass is required.
	exec { 'xbps_update1':
		command => '/usr/bin/yes y | /usr/bin/xbps-install --sync --update',
		creates => '/tmp/puppet_xbps_synced1',
	}
	exec { 'xbps_update2':
		command => '/usr/bin/yes y | /usr/bin/xbps-install --sync --update',
		creates => '/tmp/puppet_xbps_synced2',
	}
	exec { 'xbps_update3':
		command => '/usr/bin/yes y | /usr/bin/xbps-install --sync --update',
		creates => '/tmp/puppet_xbps_synced3',
	}
}
