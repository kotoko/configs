class ntp::package {
	void::package { 'chrony':
		ensure => 'installed',
	}
}