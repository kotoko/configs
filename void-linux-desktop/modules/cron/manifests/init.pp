# Install system cron.
class cron {
	class { 'cron::package': }
	class { 'cron::config': }
	class { 'cron::service': }

	Class['cron::package'] ->
	Class['cron::config'] ->
	Class['cron::service']
}
