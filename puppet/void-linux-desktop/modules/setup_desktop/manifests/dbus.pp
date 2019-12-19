# Add dbus to autostart.
class setup_desktop::dbus {
	void::package { 'dbus':
		ensure => 'installed',
	}

	void::service { 'dbus':
		enable => true,
		require => Void::Package['dbus'],
	}
}
