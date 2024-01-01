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

	file { '/etc/pipewire':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	file { '/etc/pipewire/pipewire.conf.d':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0755',
	}

	file { '/etc/pipewire/pipewire.conf.d/10-wireplumber.conf':
		ensure => 'link',
		target => '/usr/share/examples/wireplumber/10-wireplumber.conf',
		owner => 'root',
		group => 'root',
		mode => '0644',
		backup => false,
	}

	file { '/etc/pipewire/pipewire.conf.d/20-pipewire-pulse.conf':
		ensure => 'link',
		target => '/usr/share/examples/pipewire/20-pipewire-pulse.conf',
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

	File['/etc/pipewire'] ->
	File['/etc/pipewire/pipewire.conf.d'] ->
	File['/etc/pipewire/pipewire.conf.d/10-wireplumber.conf'] ->
	File['/etc/pipewire/pipewire.conf.d/20-pipewire-pulse.conf']
}
