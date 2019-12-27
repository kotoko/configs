class cups::config {
	['lp', 'lpadmin'].each |String $group| {
		group { $group:
			ensure   => 'present',
			provider => 'groupadd',
		}
	}
}