class pipewire::config {
	file { '/etc/alsa/conf.d/50-pipewire.conf':
		ensure => 'link',
		target => '/usr/share/alsa/alsa.conf.d/50-pipewire.conf',
		owner => 'root',
		group => 'root',
		backup => false,
	}

	file { '/etc/alsa/conf.d/99-pipewire-default.conf':
		ensure => 'link',
		target => '/usr/share/alsa/alsa.conf.d/99-pipewire-default.conf',
		owner => 'root',
		group => 'root',
		backup => false,
	}

	file { '/etc/security/limits.d/95-pipewire.conf':
		ensure => 'file',
		source => 'puppet:///modules/pipewire/95-pipewire.conf',
		owner => 'root',
		group => 'root',
		backup => false,
	}

	file { '/etc/xdg/autostart/pipewire.desktop':
		ensure => 'link',
		target => '/usr/share/applications/pipewire.desktop',
		owner => 'root',
		group => 'root',
		mode => '0644',
		backup => false,
	}

	file { '/etc/xdg/autostart/pipewire-pulse.desktop':
		ensure => 'link',
		target => '/usr/share/applications/pipewire-pulse.desktop',
		owner => 'root',
		group => 'root',
		mode => '0644',
		backup => false,
	}

	file { '/etc/xdg/autostart/wireplumber.desktop':
		ensure => 'link',
		target => '/usr/share/applications/wireplumber.desktop',
		owner => 'root',
		group => 'root',
		mode => '0644',
		backup => false,
	}

	File['/etc/alsa/conf.d'] ->
	File['/etc/alsa/conf.d/50-pipewire.conf'] ->
	File['/etc/alsa/conf.d/99-pipewire-default.conf']

	File['/etc/xdg'] ->
	File['/etc/xdg/autostart'] ->
	File['/etc/xdg/autostart/pipewire.desktop'] ->
	File['/etc/xdg/autostart/pipewire-pulse.desktop'] ->
	File['/etc/xdg/autostart/wireplumber.desktop']
}
