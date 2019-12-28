class users::create_directories (
	Array[Tuple[String, String]] $users,
	Array[String] $directories,
) {
	$users.each |Tuple[String, String] $u| {
		$user = $u[0]

		file { "/home/${user}":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		$directories.each |String $dir| {
			file { "/home/${user}/${dir}":
				ensure => 'directory',
				backup => false,
				owner => $user,
				mode => '0750',
			}

			File["/home/${user}"] ->
			File["/home/${user}/${dir}"]
		}
	}
}
