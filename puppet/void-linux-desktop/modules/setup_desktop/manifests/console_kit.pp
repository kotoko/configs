# Install ConsoleKit2.
class setup_desktop::console_kit {
	void::package { 'ConsoleKit2':
		ensure => 'installed',
	}

	void::service { 'consolekit':
		enable => true,
		require => Void::Package['ConsoleKit2'],
	}

	# 'cgmanager' is a dependency of 'ConsoleKit2'.
	void::service { 'cgmanager':
		enable => true,
		require => Void::Package['ConsoleKit2'],
	}
}
