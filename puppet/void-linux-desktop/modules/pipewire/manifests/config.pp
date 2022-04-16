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

	File['/etc/alsa/conf.d'] ->
	File['/etc/alsa/conf.d/50-pipewire.conf'] ->
	File['/etc/alsa/conf.d/99-pipewire-default.conf']
}