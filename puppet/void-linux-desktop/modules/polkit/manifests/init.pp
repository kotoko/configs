class polkit {
	class { 'polkit::package': }
	class { 'polkit::config': }

	Class['polkit::package'] ->
	Class['polkit::config']
}
