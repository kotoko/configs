# Set system timezone.
class timezone (
	String $timezone,
) {
	file { '/etc/localtime':
		ensure => 'link',
		target => "/usr/share/zoneinfo/${timezone}",
		owner => 'root',
		backup => false,
	}
}
