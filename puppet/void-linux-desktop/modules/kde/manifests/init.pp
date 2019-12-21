# Install KDE envirement.
class kde {
	class { 'kde::package': }
	class { 'kde::config': }

	Class['kde::package'] ->
	Class['kde::config']
}
