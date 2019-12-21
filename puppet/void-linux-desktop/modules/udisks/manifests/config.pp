class udisks::config {
	# Allow users to manage connections.
	file { '/etc/polkit-1/rules.d/52-udisks2.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/udisks/52-udisks2.rules',
	}
}
