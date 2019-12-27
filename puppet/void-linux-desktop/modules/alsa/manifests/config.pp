class alsa::config {
	group { 'audio':
		ensure   => 'present',
		provider => 'groupadd',
	}
}