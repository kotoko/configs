class ssh::service (
	Boolean $enable,
) {
	# Disable openssh daemon by default.
	void::service { 'openssh':
		enable => $enable,
	}

	void::service { 'sshguard-socklog':
		enable => true,
	}
}
