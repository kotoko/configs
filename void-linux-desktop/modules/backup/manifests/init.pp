class backup {
	class {'backup::user': }
	class {'backup::config': }

	Group['ssh_users'] ->
	Class['sddm::config'] ->
	Class['backup::user'] ->
	Class['backup::config']
}