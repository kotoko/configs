# Set system timezone.
class setup_desktop::timezone {
	$tz = 'Europe/Warsaw'

	file { '/etc/localtime':
		ensure => 'link',
		target => "/usr/share/zoneinfo/${tz}",
		owner => 'root',
		backup => false,
	}
}
