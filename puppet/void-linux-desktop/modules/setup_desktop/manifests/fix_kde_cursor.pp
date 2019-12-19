define setup_desktop::fix_kde_cursor (
	String $user
) {
	# Fix KDE cursor
	# https://wiki.archlinux.org/index.php/KDE#Plasma_cursor_sometimes_shown_incorrectly
	file { "/home/${user}/.icons":
		ensure => 'directory',
		backup => false,
		owner => $user,
		mode => '0750',
		require => [
			User[$user],
			File["/home/${user}"],
		],
	}

	file { "/home/${user}/.icons/default":
		ensure => 'directory',
		backup => false,
		owner => $user,
		mode => '0750',
		require => [
			User[$user],
			File["/home/${user}/.icons"],
		],
	}

	file { "/home/${user}/.icons/default/index.theme":
		ensure => 'file',
		backup => false,
		owner => $user,
		mode => '0750',
		source => 'puppet:///modules/setup_desktop/fix_kde_cursor/index.theme',
		require => [
			User[$user],
			File["/home/${user}/.icons/default"],
		],
	}

	file { "/home/${user}/.icons/default/cursors":
		ensure => 'link',
		backup => false,
		owner => $user,
		mode => '0750',
		target => '/usr/share/icons/breeze_cursors/cursors',
		require => [
			User[$user],
			File["/home/${user}/.icons/default"],
		],
	}
}
