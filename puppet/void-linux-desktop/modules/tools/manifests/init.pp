class tools {
	class { 'tools::package': }
	class { 'tools::config': }

	Class['tools::package'] ->
	Class['tools::config']
}
