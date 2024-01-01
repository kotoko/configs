class grub::package {
	void::package {'grub':
		ensure => 'installed',
	}
}
