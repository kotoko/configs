class users (
	Array[Tuple[String, String]] $users,
	Array[String] $groups,
	Array[String] $directories,
) {
	class { 'users::add_groups': }

	class { 'users::add_users':
		users => $users,
		groups => $groups,
	}

	class { 'users::create_directories':
		users => $users,
		directories => $directories,
	}

	class { 'users::fix_kde_cursor':
		users => $users,
	}

	class { 'users::bashrc':
		users => $users,
	}

	class { 'users::psd':
		users => $users,
	}

	Class['users::add_groups'] ->
	Class['users::add_users'] ->
	Class['users::create_directories'] ->
	Class['users::fix_kde_cursor'] ->
	Class['users::bashrc'] ->
	Class['users::psd']
}
