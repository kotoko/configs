class ssh::service (
	Boolean $enable,
) {
	void::service { 'sshd':
		enable => $enable,
	}

	void::service { 'sshguard-socklog':
		enable => true,
	}
}
