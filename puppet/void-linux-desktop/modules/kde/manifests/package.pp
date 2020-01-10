class kde::package {
	$pkgs = [
		'ark',
		'dolphin',
		'gwenview',
		'falkon',
		'filelight',
		'k3b',
		'kaddressbook',
		# 'kamoso',
		'kate5',
		'kexi',
		'kcalc',
		'kcharselect',
		'kcolorchooser',
		'kdeconnect',
		'kdenlive',
		'kgpg',
		'kmag',
		'kmail',
		'kmix',
		'kolourpaint',
		'kompare',
		'konsole',
		'konversation',
		'korganizer',
		'krename',
		'kronometer',
		'krdc',
		'krita',
		'krusader',
		'kteatime',
		'ktorrent',
		'kwalletmanager',
		# 'kwave',
		'okular',
		'plasma-browser-integration',
		'skanlite',
		'spectacle',
		'upower',
		'yakuake',
	]

	void::package { 'kde5':
		ensure => 'installed',
	}

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}

		Void::Package['kde5'] ->
		Void::Package[$pkg]
	}
}
