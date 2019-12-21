# Set grub timeout.
class grub::config (
	Integer $timeout,
) {
	exec { 'sed_GRUB_TIMEOUT':
		command => "/sbin/sed -i 's/^GRUB_TIMEOUT=.*\$/GRUB_TIMEOUT=${timeout}/' /etc/default/grub",
	}
}
