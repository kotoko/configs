class console_kit::service {
	void::service { 'consolekit':
		enable => true,
	}

	# 'cgmanager' is a dependency of 'ConsoleKit2'.
	void::service { 'cgmanager':
		enable => true,
	}
}
