# Install ConsoleKit2.
class console_kit {
	class { 'console_kit::package': }
	class { 'console_kit::service': }

	Class['console_kit::package'] ->
	Class['console_kit::service']
}
