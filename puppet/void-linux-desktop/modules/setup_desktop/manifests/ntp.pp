# Install system ntp client.
class setup_desktop::ntp {
	$pkg = 'chrony'

	void::package { $pkg:
		ensure => 'installed',
	}

	void::service { $pkg:
		enable => true,
		require => Void::Package[$pkg],
	}
}
