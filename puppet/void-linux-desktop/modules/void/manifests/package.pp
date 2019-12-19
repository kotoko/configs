define void::package (
	String $pkg = $title,
	String $ensure = 'installed',
) {
	if $ensure == 'installed' {
		exec { "xbps-install ${pkg}":
			cwd => '/root',
			command => "/usr/bin/yes y | /usr/bin/xbps-install ${pkg}",
		}
	} elsif $ensure == 'absent' {
		exec { "xbps-remove ${pkg}":
			cwd => '/root',
			command => "/usr/bin/yes y | /usr/bin/xbps-remove ${pkg}",
		}
	}
}
