class ssh (
	Boolean $enable,
) {
	class { 'ssh::package': }
	class { 'ssh::config': }
	class { 'ssh::service': enable => $enable }

	Class['ssh::package'] ->
	Class['ssh::config'] ->
	Class['ssh::service']
}
