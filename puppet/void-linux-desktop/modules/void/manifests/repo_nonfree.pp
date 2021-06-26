class void::repo_nonfree {
	void::package { 'void-repo-nonfree':
		ensure => 'installed',
	}

	exec { 'repo_nonfree_synchronize':
		command => '/usr/bin/yes y | /usr/bin/xbps-install --sync',
	}

	Void::Package['void-repo-nonfree'] ->
	Exec['repo_nonfree_synchronize']
}
