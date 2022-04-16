define void::service (
	String $srv = $title,
	Boolean $enable = true,
) {
	if $enable {
		file { "/var/service/${srv}":
			ensure => 'link',
			target => "/etc/sv/${srv}",
			owner => 'root',
			group => 'root',
		}
	} else {
		tidy { "/var/service/${srv}": }
	}
}
