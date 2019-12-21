class users::fix_kde_cursor (
	Array[Tuple[String, String]] $users,
) {
	$users.each |Tuple[String, String] $u| {
		$user = $u[0]

		# Fix KDE cursor
		# https://wiki.archlinux.org/index.php/KDE#Plasma_cursor_sometimes_shown_incorrectly
		file { "/home/${user}/.icons":
			ensure  => 'directory',
			backup  => false,
			owner   => $user,
			mode    => '0750',
		}

		file { "/home/${user}/.icons/default":
			ensure  => 'directory',
			backup  => false,
			owner   => $user,
			mode    => '0750',
		}

		file { "/home/${user}/.icons/default/index.theme":
			ensure  => 'file',
			backup  => false,
			owner   => $user,
			mode    => '0750',
			source  => 'puppet:///modules/users/index.theme',
		}

		file { "/home/${user}/.icons/default/cursors":
			ensure  => 'link',
			backup  => false,
			owner   => $user,
			mode    => '0750',
			target  => '/usr/share/icons/breeze_cursors/cursors',
			require => [
				User[$user],
				File["/home/${user}/.icons/default"],
			],
		}

		File["/home/${user}/.icons"] ->
		File["/home/${user}/.icons/default"]

		File["/home/${user}/.icons/default"] ->
		File["/home/${user}/.icons/default/index.theme"]

		File["/home/${user}/.icons/default"] ->
		File["/home/${user}/.icons/default/cursors"]
	}
}
