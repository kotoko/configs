# Install xorg.
class xorg {
	class { 'xorg::package': }
	class { 'xorg::config': }

	Class['xorg::package']->
	Class['xorg::config']
}
