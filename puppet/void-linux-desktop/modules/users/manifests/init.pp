class users (
	Array[Tuple[String, String]] $users,
	Array[String] $groups,
	Array[String] $directories,
	Boolean $apulse,
	Boolean $pipewire_autostart,
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

	class { 'users::cache_to_ram': }

	class { 'users::app_shortcuts':
		users => $users,
		apulse => $apulse,
	}

	class { 'users::fonts':
		users => $users,
	}

	class { 'users::vlc':
		users => $users,
	}

	if $pipewire_autostart {
		class { 'users::pipewire_autostart':
			users => $users,
		}

		Class['users::create_directories'] ->
		Class['users::pipewire_autostart']
	}

	Class['users::add_groups'] ->
	Class['users::add_users'] ->
	Class['users::create_directories'] ->
	Class['users::fix_kde_cursor'] ->
	Class['users::bashrc'] ->
	Class['users::psd'] ->
	Class['users::cache_to_ram'] ->
	Class['users::app_shortcuts'] ->
	Class['users::fonts'] ->
	Class['users::vlc']
}
