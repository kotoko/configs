class users::psd (
	Array[Tuple[String, String]] $users,
) {
	$psd_bins = [
		'profile-sync-daemon.sh',
		'shutdown.sh',
		'startup.sh',
	]

	$psd_browsers = [
		'chromium',
		'chromium-dev',
		'conkeror.mozdev.org',
		'epiphany',
		'falkon',
		'firefox',
		'firefox-trunk',
		'google-chrome',
		'google-chrome-beta',
		'google-chrome-unstable',
		'heftig-aurora',
		'icecat',
		'inox',
		'luakit',
		'midori',
		'opera',
		'opera-beta',
		'opera-developer',
		'opera-legacy',
		'opera-next',
		'otter-browser',
		'palemoon',
		'qupzilla',
		'qutebrowser',
		'rekonq',
		'seamonkey',
		'surf',
		'vivaldi',
		'vivaldi-snapshot',
	]

	$users.each |Tuple[String, String] $u| {
		$user = $u[0]

		file { "/home/${user}/.bin/psd":
			ensure => 'directory',
			backup => false,
			owner => $user,
			group => $user,
			mode => '0750',
		}

		file { "/home/${user}/.bin/psd/browsers":
			ensure => 'directory',
			backup => false,
			owner => $user,
			group => $user,
			mode => '0750',
		}

		file { "/home/${user}/.config/psd":
			ensure => 'directory',
			backup => false,
			owner => $user,
			group => $user,
			mode => '0750',
		}

		file { "/home/${user}/.config/psd/psd.conf":
			ensure => 'file',
			backup => false,
			owner => $user,
			group => $user,
			mode => '0640',
			source => "puppet:///modules/users/psd/config/psd.conf",
		}

		$psd_bins.each |String $bin| {
			file { "/home/${user}/.bin/psd/$bin":
				ensure => 'file',
				backup => false,
				owner => $user,
				group => $user,
				mode => '0750',
				source => "puppet:///modules/users/psd/bin/$bin",
			}

			File["/home/${user}/.bin/psd"] ->
			File["/home/${user}/.bin/psd/$bin"]
		}

		$psd_browsers.each |String $browser| {
			file { "/home/${user}/.bin/psd/browsers/$browser":
				ensure => 'file',
				backup => false,
				owner => $user,
				group => $user,
				mode => '0640',
				source => "puppet:///modules/users/psd/bin/browsers/$browser",
			}

			File["/home/${user}/.bin/psd/browsers"] ->
			File["/home/${user}/.bin/psd/browsers/$browser"]
		}


		File["/home/${user}/.bin"] ->
		File["/home/${user}/.bin/psd"] ->
		File["/home/${user}/.bin/psd/browsers"]

		File["/home/${user}/.config"] ->
		File["/home/${user}/.config/psd"] ->
		File["/home/${user}/.config/psd/psd.conf"]
	}
}