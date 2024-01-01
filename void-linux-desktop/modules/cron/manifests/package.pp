class cron::package {
	void::package { 'cronie':
		ensure => 'installed',
	}
}