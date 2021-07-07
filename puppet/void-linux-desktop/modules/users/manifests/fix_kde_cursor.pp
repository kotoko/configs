class users::fix_kde_cursor (
	Array[Tuple[String, String]] $users,
) {
	# Configuration for normal users
	$users.each |Tuple[String, String] $u| {
		$user = $u[0]

		# Fix KDE cursor
		# https://wiki.archlinux.org/index.php/KDE#Plasma_cursor_sometimes_shown_incorrectly
		file { "/home/${user}/.icons":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		file { "/home/${user}/.icons/default":
			ensure => 'directory',
			backup => false,
			owner => $user,
			mode => '0750',
		}

		file { "/home/${user}/.icons/default/index.theme":
			ensure => 'file',
			backup => false,
			owner => $user,
			mode => '0750',
			source => 'puppet:///modules/users/index.theme',
		}

		file { "/home/${user}/.icons/default/cursors":
			ensure => 'link',
			backup => false,
			owner => $user,
			mode => '0750',
			target => '/usr/share/icons/breeze_cursors/cursors',
		}

		File["/home/${user}/.icons"] ->
		File["/home/${user}/.icons/default"] ->
		File["/home/${user}/.icons/default/index.theme"] ->
		File["/home/${user}/.icons/default/cursors"]
	}

	# Configuration for new accounts created in future
	file { "/etc/skel/.icons":
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0750',
	}
	file { "/etc/skel/.icons/default":
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0750',
	}
	file { "/etc/skel/.icons/default/index.theme":
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0750',
		source => 'puppet:///modules/users/index.theme',
	}
	file { "/etc/skel/.icons/default/cursors":
		ensure => 'link',
		backup => false,
		owner => 'root',
		mode => '0750',
		target => '/usr/share/icons/breeze_cursors/cursors',
	}

	File["/etc/skel/.icons"] ->
	File["/etc/skel/.icons/default"] ->
	File["/etc/skel/.icons/default/index.theme"] ->
	File["/etc/skel/.icons/default/cursors"]
}
