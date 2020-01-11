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

		file { "/home/${user}/.bin":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		file { "/home/${user}/.config":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		file { "/home/${user}/.config/plasma-workspace":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		file { "/home/${user}/.config/plasma-workspace/env":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		file { "/home/${user}/.config/plasma-workspace/shutdown":
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

		File["/home/${user}"] ->
		File["/home/${user}/.bin"]

		File["/home/${user}"] ->
		File["/home/${user}/.config"] ->
		File["/home/${user}/.config/plasma-workspace"] ->
		File["/home/${user}/.config/plasma-workspace/env"] ->
		File["/home/${user}/.config/plasma-workspace/shutdown"]
	}
}
