class cups::service {
	void::service { 'cupsd':
		enable => true,
	}
}
