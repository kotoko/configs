class users::add_groups (
	Array[String] $groups,
) {
	$groups.each |String $group| {
		group { $group:
			ensure   => 'present',
			provider => 'groupadd',
		}
	}
}
