class users::cache_to_ram {
	file { '/etc/profile.d/xdg_cache_home.sh':
		ensure => 'file',
		backup => false,
		owner => $user,
		mode => '0644',
		source => 'puppet:///modules/users/xdg_cache_home.sh',
	}
}