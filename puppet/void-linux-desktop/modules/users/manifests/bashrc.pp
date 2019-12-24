class users::bashrc (
	Array[Tuple[String, String]] $users,
) {
	$users.each |Tuple[String, String] $u| {
		$user = $u[0]

		file { "/home/${user}/.bashrc":
			ensure => 'file',
			backup => false,
			owner => $user,
			mode => '0644',
			source => 'puppet:///modules/users/bashrc',
		}
	}
}