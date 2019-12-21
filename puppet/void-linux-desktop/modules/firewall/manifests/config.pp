class firewall::config {
	file { '/etc/iptables':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/iptables/iptables.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/firewall/iptables.rules',
	}

	file { '/etc/iptables/ip6tables.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/firewall/ip6tables.rules',
	}

	file { '/etc/ipset':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/ipset/ipset.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/firewall/ipset.rules',
	}

	File['/etc/iptables'] ->
	File['/etc/iptables/iptables.rules']

	File['/etc/iptables'] ->
	File['/etc/iptables/ip6tables.rules']

	File['/etc/ipset'] ->
	File['/etc/ipset/ipset.rules']
}
