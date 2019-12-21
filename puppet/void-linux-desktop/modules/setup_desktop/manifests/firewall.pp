# Configure firewall.
class setup_desktop::firewall {
	void::package { 'iptables':
		ensure => 'installed',
	}

	void::package { 'ipset':
		ensure => 'installed',
	}

	# Saving/restoring rules on shutdown/startup.
	file { '/etc/rc.local':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/setup_desktop/firewall/rc.local',
	}

	file { '/etc/rc.shutdown':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/setup_desktop/firewall/rc.shutdown',
	}

	# Rules.
	file { '/etc/iptables/iptables.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/firewall/iptables.rules',
		require => Void::Package['iptables'],
	}

	file { '/etc/iptables/ip6tables.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/firewall/ip6tables.rules',
		require => Void::Package['iptables'],
	}

	file { '/etc/ipset':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
		require => Void::Package['ipset'],
	}

	file { '/etc/ipset/ipset.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/firewall/ipset.rules',
		require => [
			Void::Package['ipset'],
			File['/etc/ipset'],
		],
	}

	# Load rules now.
	exec { 'ipset_restore':
		command => '/sbin/ipset restore < /etc/ipset/ipset.rules',
		require => [
			Void::Package['ipset'],
			File['/etc/ipset/ipset.rules'],
		]
	}

	exec { 'ip6tables-restore':
		command => '/sbin/ip6tables-restore -c /etc/iptables/ip6tables.rules',
		require => [
			Void::Package['iptables'],
			File['/etc/iptables/ip6tables.rules'],
			Exec['ipset_restore'],
		]
	}

	exec { 'iptables-restore':
		command => '/sbin/iptables-restore -c /etc/iptables/iptables.rules',
		require => [
			Void::Package['iptables'],
			File['/etc/iptables/iptables.rules'],
			Exec['ipset_restore'],
		]
	}

}
