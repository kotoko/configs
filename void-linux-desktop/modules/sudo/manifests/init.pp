class sudo {
	class { 'sudo::package': }
	class { 'sudo::config': }

	Class['sudo::package']->
	Class['sudo::config']
}