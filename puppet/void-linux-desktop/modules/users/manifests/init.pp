class users (
	Array[Tuple[String, String]] $users,
	Array[String] $groups,
	Array[String] $directories,
) {
	class { 'users::add_groups':
		groups => $groups,
	}

	class { 'users::add_users':
		users => $users,
		groups => $groups,
	}

	class { 'users::create_directories':
		directories => $directories,
	}

	class { 'users::fix_kde_cursor':
		users => $users,
	}

}
