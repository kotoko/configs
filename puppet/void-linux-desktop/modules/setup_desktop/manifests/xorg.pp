# Install xorg.
class setup_desktop::xorg {
	void::package { 'xorg':
		ensure => 'installed',
	}
}
