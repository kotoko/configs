class tlp {
	class { 'tlp::package': }
	class { 'tlp::config': }
	class { 'tlp::service': }

	Class['tlp::package'] ->
	Class['tlp::config'] ->
	Class['tlp::service']
}
