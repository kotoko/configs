class syslog::service {
	void::service { 'socklog-unix':
		enable => true,
	}

	void::service { 'nanoklogd':
		enable => true,
	}
}