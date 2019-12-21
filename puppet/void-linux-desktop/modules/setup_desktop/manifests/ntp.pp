# Install system ntp client.
class setup_desktop::ntp {
	void::package { 'chrony':
		ensure => 'installed',
	}

	void::service { 'chronyd':
		enable => true,
		require => Void::Package['chrony'],
	}
}
