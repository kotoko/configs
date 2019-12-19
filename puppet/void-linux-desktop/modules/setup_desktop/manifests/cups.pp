# Install CUPS.
class setup_desktop::cups {
	void::package { 'cups':
		ensure => 'installed',
	}

	void::service { 'cupsd':
		enable => true,
		require => Void::Package['cups'],
	}

	void::package { 'cups-filters':
		ensure => 'installed',
		require => Void::Package['cups'],
	}

	$pkgs = ['gutenprint', 'hplip', 'foomatic-db']
	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
			require => Void::Package['cups-filters'],
		}
	}

}
