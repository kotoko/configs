class shutdown_permission::polkit {
	file { '/etc/polkit-1/rules.d/51-shutdown.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/shutdown_permission/51-shutdown.rules',
	}
}
