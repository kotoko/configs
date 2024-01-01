# Disable tty service.
define disable_ttys::disable  (
	$nr
) {
	tidy { "/var/service/agetty-tty${nr}": }

	file { "/etc/sv/agetty-tty${nr}/down":
		ensure => 'file',
		owner => 'root',
		group => 'root',
	}
}
