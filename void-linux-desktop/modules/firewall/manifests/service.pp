class firewall::service {
	# Saving/restoring rules on shutdown/startup.
	file { '/etc/rc.local':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/firewall/rc.local',
	}

	file { '/etc/rc.shutdown':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/firewall/rc.shutdown',
	}
}
