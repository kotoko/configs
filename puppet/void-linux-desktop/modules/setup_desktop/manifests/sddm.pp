# Install sddm.
class setup_desktop::sddm {
	void::package { 'sddm':
		ensure => 'installed',
	}

	# Autostart.
	void::service { 'sddm':
		enable => true,
		require => Void::Package['sddm'],
	}

	# Generate default config.
	file { '/etc/sddm.conf':
		ensure => 'file',
		owner => 'root',
		mode => '0644',
		require => Void::Package['sddm'],
	}

	exec { 'sddm_example_config':
		cwd => '/root',
		command => '/sbin/sddm --example-config > /etc/sddm.conf',
		require => [
			File['/etc/sddm.conf'],
			Void::Package['sddm'],
		],
	}

	# Adjust sddm config with sed.
	exec { 'sddm_config':
		cwd => '/root',
		command => '/sbin/sed -i -e "s/^\(Current=\).*$/\1breeze/" -e "s/^\(CursorTheme=\).*$/\1breeze_cursors/" -e "s/^\(RememberLastUser=\).*$/\1true/" -e "s/^\(RememberLastSession=\).*$/\1true/" -e "s/^\(ReuseSession=\).*$/\1true/" -e "s/^\(EnableAvatars=\).*$/\1true/" /etc/sddm.conf',
		require => [
			Exec['sddm_example_config'],
			Void::Package['sddm'],
		],
	}

	# Background for sddm.
	file { '/usr/share/sddm/themes/breeze/Next Theme KDE Wallpaper Material Version.png':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/sddm/Next Theme KDE Wallpaper Material Version.png',
		require => [
			Exec['sddm_config'],
			Void::Package['sddm'],
			Void::Package['kde5'],
		]
	}

	file { '/usr/share/sddm/themes/breeze/theme.conf.user':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/sddm/theme.conf.user',
		require => [
			Exec['sddm_config'],
			Void::Package['sddm'],
			Void::Package['kde5'],
		]
	}
}
