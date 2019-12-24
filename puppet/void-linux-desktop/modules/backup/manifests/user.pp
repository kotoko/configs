class backup::user {
	user { $user:
		ensure => 'present',
		provider => 'useradd',
		groups => ['ssh_users'],
		shell => '/bin/bash',
	}
}