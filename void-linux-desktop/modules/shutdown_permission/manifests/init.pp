# Allow users to shutdown computer.
class shutdown_permission (
	Boolean $sudo = false,
	Boolean $polkit = false,
) {
	if $sudo {
		class { 'shutdown_permission::sudo': }

		Class['sudo::package'] ->
		Class['shutdown_permission::sudo']
	}

	if $polkit {
		class { 'shutdown_permission::polkit': }

		Class['polkit::package'] ->
		Class['shutdown_permission::polkit']
	}
}
