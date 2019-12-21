class users::add_users (
	Array[Tuple[String, String]] $users,
	Array[String] $groups,
) {
	$users.each |Tuple[String, String] $u| {
		$user = $u[0]
		$user_name = $u[1]

		user { $user:
			ensure => 'present',
			provider => 'useradd',
			comment => $user_name,
			groups => $groups,
			shell => '/bin/bash',
		}
	}
}
