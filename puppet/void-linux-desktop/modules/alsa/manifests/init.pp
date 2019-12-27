# Install Alsa.
class alsa {
	class { 'alsa::package': }
	class { 'alsa::config': }
	class { 'alsa::service': }

	Class['alsa::package'] ->
	Class['alsa::config'] ->
	Class['alsa::service']
}
