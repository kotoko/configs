class setup_desktop::java {
	void::package { 'openjdk-jre':
		ensure => 'installed',
	}
}

