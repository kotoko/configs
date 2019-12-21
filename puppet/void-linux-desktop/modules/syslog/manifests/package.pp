class syslog::package {
	void::package { 'socklog-void':
		ensure => 'installed',
	}
}