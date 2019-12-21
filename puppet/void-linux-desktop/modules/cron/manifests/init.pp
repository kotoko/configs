# Install system cron.
class cron {
	class { 'cron::package': }
	class { 'cron::service': }

	Class['cron::package'] ->
	Class['cron::service']
}
