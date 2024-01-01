class cups::package {
	void::package { 'cups':
		ensure => 'installed',
	}

	void::package { 'cups-filters':
		ensure => 'installed',
	}

	$pkgs = ['gutenprint', 'hplip', 'foomatic-db']
	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}

		Void::Package['cups-filters'] ->
		Void::Package[$pkg]
	}

	Void::Package['cups'] ->
	Void::Package['cups-filters']
}
