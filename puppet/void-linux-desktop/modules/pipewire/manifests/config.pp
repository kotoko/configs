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

	file { '/usr/bin/void-pipewire-launcher':
		ensure => 'file',
		source => 'puppet:///modules/pipewire/void-pipewire-launcher',
		owner => 'root',
		group => 'root',
		mode => '0755',
		backup => false,
	}

	file { '/etc/xdg/autostart/pipewire.desktop':
		ensure => 'file',
		source => 'puppet:///modules/pipewire/pipewire.desktop',
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
	File['/etc/xdg/autostart/pipewire.desktop']
}
