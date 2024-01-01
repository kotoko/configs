class ntp::service {
	void::service { 'chronyd':
		enable => true,
	}
}