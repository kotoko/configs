# Install CUPS.
class cups {
	class { 'cups::package': }
	class { 'cups::service': }

	Class['cups::package'] ->
	Class['cups::service']
}
