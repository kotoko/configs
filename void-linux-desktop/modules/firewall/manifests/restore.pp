class firewall::restore {
	exec { 'ipset_restore':
		command => '/sbin/ipset restore < /etc/ipset/ipset.rules',
	}

	exec { 'ip6tables-restore':
		command => '/sbin/ip6tables-restore -c /etc/iptables/ip6tables.rules',
	}

	exec { 'iptables-restore':
		command => '/sbin/iptables-restore -c /etc/iptables/iptables.rules',
	}
}
