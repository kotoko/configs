node default {
	class { 'setup_desktop':
		users => [
			['jan', 'Jan Kowalski'],
			['ewa', 'Ewa Nowak'],
		],
		cpu => 'intel',
		gpu => 'intel',
		timezone => 'Europe/Warsaw',
		enable_ssh => false,
	}
}
