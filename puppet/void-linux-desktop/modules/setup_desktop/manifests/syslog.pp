# Install system logging.
class setup_desktop::syslog {
	void::package { 'socklog-void':
		ensure => 'installed',
	}

	void::service { 'socklog-unix':
		enable => true,
		require => Void::Package['socklog-void'],
	}

	void::service { 'nanoklogd':
		enable => true,
		require => Void::Package['socklog-void'],
	}
}
