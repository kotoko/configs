# Install blueetoth.
class bluetooth {
	class { 'bluetooth::package': }
	class { 'bluetooth::service': }

	Class['bluetooth::package'] ->
	Class['bluetooth::service']
}
