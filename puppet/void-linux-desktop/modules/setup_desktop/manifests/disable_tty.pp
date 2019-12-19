# Disable tty service.
define setup_desktop::disable_tty (
	$nr
) {
	tidy { "/var/service/agetty-tty${nr}": }

	file { "/etc/sv/agetty-tty${nr}/down":
		ensure => 'file',
		owner => 'root',
	}
}
