class cron::service {
	void::service { 'cronie':
		enable => true,
	}
}