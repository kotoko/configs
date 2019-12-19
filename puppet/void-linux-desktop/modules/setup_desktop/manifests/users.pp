class setup_desktop::users (
	Array[Tuple[String, String]] $users,
) {
	$groups = ['audio', 'bluetooth', 'input', 'lp', 'lpadmin', 'network', 'plugdev', 'video', 'users']
	$groups.each |String $group| {
		group { $group:
			ensure => 'present',
			provider => 'groupadd',
		}
	}

	$users.each |Tuple[String, String] $u| {
		$user = $u[0]
		$user_name = $u[1]

		user { $user:
			ensure => 'present',
			provider => 'useradd',
			comment => $user_name,
			groups => $groups,
			shell => '/bin/bash',
			require => Group[$groups],
		}

		file { "/home/${user}":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
			require => User[$user],
		}

		$folders = ['Dokumenty', 'Filmy', 'Muzyka', 'Obrazy', 'Pobrane', 'Pulpit']
		$folders.each |String $dir| {
			file { "/home/${user}/${dir}":
				ensure => 'directory',
				backup => false,
				owner => $user,
				mode => '0750',
				require => [
					File["/home/${user}"],
					User[$user],
				],
			}
		}

		setup_desktop::fix_kde_cursor { $user:
			user => $user,
			require => [
				User[$user],
				File["/home/${user}"],
			],
		}
	}
}
