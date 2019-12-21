# Install system ntp client.
class ntp {
	class { 'ntp::package': }
	class { 'ntp::service': }

	Class['ntp::package'] -> Class['ntp::service']
}
