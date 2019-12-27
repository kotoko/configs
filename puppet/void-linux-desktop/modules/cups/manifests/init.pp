# Install CUPS.
class cups {
	class { 'cups::package': }
	class { 'cups::config': }
	class { 'cups::service': }

	Class['cups::package'] ->
	Class['cups::config'] ->
	Class['cups::service']
}
