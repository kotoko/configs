class shutdown_permission::sudo {
	file { '/etc/sudoers.d/shutdown':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/shutdown_permission/sudo_shutdown',
	}

	File['/etc/sudoers.d'] ->
	File['/etc/sudoers.d/shutdown']
}
