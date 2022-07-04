# Install rtkit.
class rtkit {
	class { 'rtkit::package': }
	class { 'rtkit::service': }

	Class['rtkit::package'] ->
	Class['rtkit::service']
}

