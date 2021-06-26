class void::repo_nonfree {
  void::package { 'void-repo-nonfree':
    ensure => 'installed',
  }
}
