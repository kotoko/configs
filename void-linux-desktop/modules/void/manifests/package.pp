define void::package (
	String $pkg = $title,
	String $ensure = 'installed',
) {
	if $ensure == 'installed' {
		exec { "xbps-install ${pkg}":
			command => "/usr/bin/xbps-install --yes ${pkg}",
		}
	} elsif $ensure == 'absent' {
		exec { "xbps-remove ${pkg}":
			command => "/usr/bin/xbps-remove --yes ${pkg}",
		}
	} else {
		    fail('Unrecognized \'ensure\' value!')
	}
}
