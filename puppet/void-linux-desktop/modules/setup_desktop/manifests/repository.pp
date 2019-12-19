# Set repository mirror to something faster than
# offcial servers.
class setup_desktop::repository {
	file { '/etc/xbps.d/00-repository-main.conf':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/setup_desktop/repository/00-repository-main.conf',
	}
}
