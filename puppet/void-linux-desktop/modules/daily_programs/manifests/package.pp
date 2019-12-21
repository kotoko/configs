class daily_programs::package {
	$pkgs = [
		'audacity',
		'calibre',
		'darktable',
		'digikam',
		# 'gimp',
		'falkon',
		'firefox-esr',
		'firefox-esr-i18n-pl',
		'focuswriter',
		'inkscape',
		'keepassxc',
		'libreoffice',
		'libreoffice-i18n-pl',
		# 'rawtherapee',
		'scribus',
		'VeraCrypt',
		'virtualbox-ose',
		'vlc',
	]

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
		}
	}
}
