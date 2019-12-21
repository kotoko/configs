class setup_desktop::daily_programs {
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

	# Permissions for veracrypt.
	file { '/etc/sudoers.d/veracrypt':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/veracrypt/sudo_veracrypt',
		require => [
			Void::Package['VeraCrypt'],
			Void::Package['sudo'],
		]
	}
}
