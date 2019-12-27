# Make sure that common groups exist. Here
# are groups that do not belong anywhere else.
class users::add_groups {
	$groups = [
		'cdrom',
		'input',
		'kvm',
		'scanner',
		'users',
		'video',
	]

	$groups.each |String $group| {
		group { $group:
			ensure   => 'present',
			provider => 'groupadd',
		}
	}
}
