define update_system::update {
	exec { $title:
		command => '/usr/bin/yes y | /usr/bin/xbps-install --sync --update',
		creates => "/tmp/puppet_xbps_synced${title}",
	}
}