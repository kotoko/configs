# Disable ttys services.
class setup_desktop::disable_ttys (
	Array[Integer] $nrs,
) {
	$nrs.each |Integer $nr| {
		setup_desktop::disable_tty { "${nr}":
			nr => $nr,
		}
	}
}
