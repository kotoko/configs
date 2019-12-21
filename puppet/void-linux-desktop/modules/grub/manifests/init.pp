class grub (
	Integer $timeout,
) {
	class { 'grub::package': }
	class { 'grub::config': timeout => $timeout }
	class { 'grub::apply': }

	Class['grub::package'] ->
	Class['grub::config'] ->
	Class['grub::apply']
}
