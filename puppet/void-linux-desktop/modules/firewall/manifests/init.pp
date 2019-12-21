# Configure firewall.
class firewall {
	class { 'firewall::package': }
	class { 'firewall::config': }
	class { 'firewall::service': }
	class { 'firewall::restore': }

	Class['firewall::package'] ->
	Class['firewall::config'] ->
	Class['firewall::service'] ->
	Class['firewall::restore']
}
