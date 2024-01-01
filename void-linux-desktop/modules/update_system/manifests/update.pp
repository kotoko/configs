define update_system::update {
	exec { $title:
		command => '/usr/bin/xbps-install --yes --sync --update',
		creates => "/tmp/puppet_xbps_synced${title}",
	}
}
