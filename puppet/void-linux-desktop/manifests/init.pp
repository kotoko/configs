node default {
	class { 'setup_desktop':
		users => [
			['jan', 'Jan Kowalski'],
			['ewa', 'Ewa Nowak'],
		],
		intel => true,  # intel processor?
	}
}
