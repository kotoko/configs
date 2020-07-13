class network_manager::config {
	group { 'network':
		ensure   => 'present',
		provider => 'groupadd',
	}
}
