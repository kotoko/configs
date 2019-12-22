class daily_programs {
	class { 'daily_programs::package': }
	class { 'daily_programs::config': }

	Class['sudo::package'] ->
	Class['daily_programs::package'] ->
	Class['daily_programs::config']
}
