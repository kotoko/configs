class daily_programs::config {
	group { 'vboxusers':
		ensure   => 'present',
		provider => 'groupadd',
	}

	# Better touchpad support for firefox
	file { '/etc/profile.d/use-xinput2.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		group => 'root',
		mode => '0644',
		source => 'puppet:///modules/daily_programs/use-xinput2.sh',
	}
}
