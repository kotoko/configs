 # Disable ttys services.
class disable_ttys (
	Array[Integer] $nrs,
) {
	$nrs.each |Integer $nr| {
		disable_ttys::disable { "${nr}":
			nr => $nr,
		}
	}
}
