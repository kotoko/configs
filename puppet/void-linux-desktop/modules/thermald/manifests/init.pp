class thermald {
	class { 'thermald::package': }
	class { 'thermald::service': }

	Class['thermald::package'] ->
	Class['thermald::service']
}
