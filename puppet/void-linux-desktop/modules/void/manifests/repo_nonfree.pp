class void::repo_nonfree {
	void::package { 'void-repo-nonfree':
		ensure => 'installed',
	}

	exec { 'repo_nonfree_synchronize':
		command => '/usr/bin/yes y | /usr/bin/xbps-install --sync',
	}

	void::package['void-repo-nonfree'] ->
	exec['repo_nonfree_synchronize']
}
