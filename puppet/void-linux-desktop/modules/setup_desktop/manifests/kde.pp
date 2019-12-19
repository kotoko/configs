# Install KDE envirement.
class setup_desktop::kde {
	$pkgs = [
		'ark',
		'dolphin',
		'gwenview',
		'k3b',
		'kaddressbook',
		'kate5',
		'kdeconnect',
		'kdenlive',
		'kgpg',
		'kmail',
		'kmix',
		'kolourpaint',
		'konsole',
		'korganizer',
		'kwalletmanager',
		'okular',
		'plasma-browser-integration',
		'spectacle',
		'yakuake',
	]

	void::package { 'kde5':
		ensure => 'installed',
	}

	$pkgs.each |String $pkg| {
		void::package { $pkg:
			ensure => 'installed',
			require => Void::Package['kde5'],
		}
	}

	# Remove 'nox11' (from pam config) from line with 'pam_ck_connector.so'.
	exec { 'sed_system-login':
		cwd => '/root',
		command => '/sbin/sed -i -r "s/(pam_ck_connector\.so)(.*)nox11(.*)$/\1\2\3/" /etc/pam.d/system-login',
		require => Void::Package['kde5'],
	}
}
