class udisks::config {
	file { '/etc/polkit-1/rules.d/53-udisks2.rules':
		ensure => 'file',
		backup => false,
		owner => 'polkitd',
		group => 'polkitd',
		mode => '0644',
		source => 'puppet:///modules/udisks/53-udisks2.rules',
	}

	group { 'plugdev':
		ensure   => 'present',
		provider => 'groupadd',
	}

	File['/etc/polkit-1/rules.d'] ->
	File['/etc/polkit-1/rules.d/53-udisks2.rules']
}
