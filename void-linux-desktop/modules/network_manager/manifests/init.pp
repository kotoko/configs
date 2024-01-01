# Install NetworkManager.
class network_manager {
	class { 'network_manager::package': }
	class { 'network_manager::config': }
	class { 'network_manager::service': }

	Class['polkit::package'] ->
	Class['network_manager::package'] ->
	Class['network_manager::config'] ->
	Class['network_manager::service']
}
