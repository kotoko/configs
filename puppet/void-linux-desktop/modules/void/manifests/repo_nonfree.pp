class void::repo_nonfree {
	void::package { 'void-repo-nonfree':
		ensure => 'installed',
	}

	exec { 'repo_nonfree_synchronize':
		command => '/usr/bin/xbps-install --yes --sync',
	}

	Void::Package['void-repo-nonfree'] ->
	Exec['repo_nonfree_synchronize']
}
