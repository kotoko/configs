class bluetooth::config {
	group { 'bluetooth':
		ensure   => 'present',
		provider => 'groupadd',
	}
}