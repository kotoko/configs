# Install blueetoth.
class bluetooth {
	class { 'bluetooth::package': }
	class { 'bluetooth::config': }
	class { 'bluetooth::service': }

	Class['bluetooth::package'] ->
	Class['bluetooth::config'] ->
	Class['bluetooth::service']
}
