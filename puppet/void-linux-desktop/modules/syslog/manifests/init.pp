# Install system logging.
class syslog {
	class { 'syslog::package': }
	class { 'syslog::service': }

	Class['syslog::package'] -> Class['syslog::service']
}
