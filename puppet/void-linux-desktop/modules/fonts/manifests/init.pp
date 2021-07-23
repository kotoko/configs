class fonts {
  void::package { 'font-firacode':
		ensure => 'installed',
	}

  void::package { 'font-adobe-source-code-pro':
		ensure => 'installed',
	}
}
