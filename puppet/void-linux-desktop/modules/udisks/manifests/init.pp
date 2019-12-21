# Install udisks2.
class udisks {
	class { 'udisks::package': }
	class { 'udisks::config': }

	Class['polkit'] ->
	Class['udisks::package'] ->
	Class['udisks::config']
}
