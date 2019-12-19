# Set system timezone.
class setup_desktop::timezone {
	$tz = 'Europe/Warsaw'

	file { "/usr/share/zoneinfo/${tz}":
		ensure => 'link',
		target => '/etc/localtime',
		owner => 'root',
		backup => false,
	}
}
