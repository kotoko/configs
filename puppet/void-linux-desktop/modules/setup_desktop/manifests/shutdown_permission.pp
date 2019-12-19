# Allow users to shutdown computer.
class setup_desktop::shutdown_permission {
	file { '/etc/polkit-1/rules.d/51-shutdown.rules':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/shutdown_permission/51-shutdown.rules',
		require => Void::Package['polkit'],
	}

	file { '/etc/sudoers.d/shutdown':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/shutdown_permission/sudo_shutdown',
		require => Void::Package['sudo'],
	}
}
