# Install udisks2.
class udisks::package {
	void::package { 'udisks2':
		ensure => 'installed',
	}
}
