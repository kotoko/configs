class kde::package {
	$pkgs = [
		'ark',
		'dolphin',
		'gwenview',
		'k3b',
		'kaddressbook',
		'kate5',
		'kdeconnect',
		'kdenlive',
		'kgpg',
		'kmail',
		'kmix',
		'kolourpaint',
		'konsole',
		'korganizer',
		'kwalletmanager',
		'okular',
		'plasma-browser-integration',
		'spectacle',
		'yakuake',
	]

	void::package { 'kde5':
		ensure => 'installed',
	}

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
			require => Void::Package['kde5'],
		}
	}
}
