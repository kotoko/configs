class kde::package {
	$pkgs = [
		'ark',
		'breeze-qt5',
		'colord',
		'colord-kde',
		'dolphin',
		'gwenview',
		'falkon',
		'filelight',
		'k3b',
		'kaddressbook',
		'kamoso',
		'kasts',
		'kdialog',
		'kexi',
		'kcalc',
		'kcharselect',
		'kcolorchooser',
		'kcron',
		'kdeconnect',
		'kdenlive',
		'kfind',
		'kgpg',
		'kimageformats',
		'libavif',
		'libheif',
		'openexr',
		'libraw',
		'kmag',
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
		'plasma-vault',
		'screenkey',
		'skanlite',
		'spectacle',
		'upower',
		'yakuake',
		'xdg-desktop-portal',
		'xdg-desktop-portal-kde',
		'xorg-server-xwayland',
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
