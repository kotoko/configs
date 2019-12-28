class xorg::config {
	group { 'video':
		ensure   => 'present',
		provider => 'groupadd',
	}
}