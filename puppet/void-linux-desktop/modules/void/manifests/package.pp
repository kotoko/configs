define void::package (
	String $pkg = $title,
	String $ensure = 'installed',
) {
	if $ensure == 'installed' {
		exec { "xbps-install ${pkg}":
			command => "/usr/bin/yes y | /usr/bin/xbps-install ${pkg}",
		}
	} elsif $ensure == 'absent' {
		exec { "xbps-remove ${pkg}":
			command => "/usr/bin/yes y | /usr/bin/xbps-remove ${pkg}",
		}
	} else {
		    fail('Unrecognized \'ensure\' value!')
	}
}
