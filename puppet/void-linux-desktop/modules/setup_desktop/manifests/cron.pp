# Install system cron.
class setup_desktop::cron {
	$pkg = 'cronie'

	void::package { $pkg:
		ensure => 'installed',
	}

	void::service { $pkg:
		enable => true,
		require => Void::Package[$pkg],
	}
}
