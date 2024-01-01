class backup::user {
	user { 'backup':
		ensure => 'present',
		provider => 'useradd',
		groups => ['ssh_users'],
		shell => '/bin/bash',
	}
}