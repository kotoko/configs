# Set grub timeout.
class setup_desktop::grub_timeout(
	$timeout = 2,
) {
	exec { 'sed_grub':
		cwd => '/root',
		command => "/sbin/sed -i 's/^GRUB_TIMEOUT=.*\$/GRUB_TIMEOUT=${timeout}/' /etc/default/grub",
	}

	exec { 'reconfigure_grub':
		cwd => '/root',
		command => "/usr/bin/grub-mkconfig -o /boot/grub/grub.cfg",
		require => Exec['sed_grub'],
	}

}
