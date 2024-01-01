class dbus {
	class { 'dbus::package': }
	class { 'dbus::service': }

	Class['dbus::package'] ->
	Class['dbus::service']
}
