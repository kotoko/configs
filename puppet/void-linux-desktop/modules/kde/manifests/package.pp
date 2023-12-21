class kde::package {
	$pkgs = [
		'ark',
		'colord',
		'colord-kde',
		'dolphin',
		'gwenview',
		'falkon',
		'filelight',
		'k3b',
		'kaddressbook',
		'kamoso',
		'kexi',
		'kcalc',
		'kcharselect',
		'kcolorchooser',
		'kdeconnect',
		'kdenlive',
		'kfind',
		'kgpg',
		'kimageformats',
		'kmag',
		'kmail',
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
		'kwave',
		'kwrite',
		'okular',
		'plasma-browser-integration',
		'screenkey',
		'skanlite',
		'spectacle',
		'upower',
		'yakuake',
		'xdg-desktop-portal',
		'xdg-desktop-portal-kde',
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
