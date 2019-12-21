class preload {
	class { 'preload::package': }
	class { 'preload::service': }

	Class['preload::package'] ->
	Class['preload::service']
}
