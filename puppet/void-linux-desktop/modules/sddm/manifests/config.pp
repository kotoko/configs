class sddm::config {
	# Generate default config.
	file { '/etc/sddm.conf':
		ensure => 'file',
		owner => 'root',
		group => 'root',
		mode => '0644',
	}

	exec { 'sddm_example_config':
		command => '/sbin/sddm --example-config > /etc/sddm.conf',
	}

	# Adjust sddm config with sed.
	exec { 'sddm_config':
		command => '/sbin/sed -i -e "s/^\(Current=\).*$/\1breeze/" -e "s/^\(CursorTheme=\).*$/\1breeze_cursors/" -e "s/^\(RememberLastUser=\).*$/\1true/" -e "s/^\(RememberLastSession=\).*$/\1true/" -e "s/^\(ReuseSession=\).*$/\1true/" -e "s/^\(EnableAvatars=\).*$/\1true/" /etc/sddm.conf',
	}

	# Background for sddm.
	file { '/usr/share/sddm/themes/breeze/Next Theme KDE Wallpaper Material Version.png':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/sddm/Next Theme KDE Wallpaper Material Version.png',
	}

	file { '/usr/share/sddm/themes/breeze/theme.conf.user':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/sddm/theme.conf.user',
	}

	File['/etc/sddm.conf'] ->
	Exec['sddm_example_config']

	Exec['sddm_example_config'] ->
	Exec['sddm_config']

	Exec['sddm_config'] ->
	File['/usr/share/sddm/themes/breeze/Next Theme KDE Wallpaper Material Version.png']

	Exec['sddm_config'] ->
	File['/usr/share/sddm/themes/breeze/theme.conf.user']
}
