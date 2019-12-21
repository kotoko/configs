# Install Alsa.
class alsa {
	class { 'alsa::package': }
	class { 'alsa::service': }

	Class['alsa::package'] ->
	Class['alsa::service']
}
