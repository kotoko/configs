class grub::apply {
	exec { 'grub-mkconfig':
		command => "/usr/bin/grub-mkconfig -o /boot/grub/grub.cfg",
	}
}
