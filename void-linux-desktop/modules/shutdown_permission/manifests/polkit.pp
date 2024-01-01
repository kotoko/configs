class shutdown_permission::polkit {
	file { '/etc/polkit-1/rules.d/52-shutdown.rules':
		ensure => 'file',
		backup => false,
		owner => 'polkitd',
		group => 'polkitd',
		mode => '0644',
		source => 'puppet:///modules/shutdown_permission/52-shutdown.rules',
	}

	File['/etc/polkit-1/rules.d'] ->
	File['/etc/polkit-1/rules.d/52-shutdown.rules']
}
