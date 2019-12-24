class kde::config {
	# Remove 'nox11' (from pam config) from line with 'pam_ck_connector.so'.
	exec { 'sed_system-login':
		command => '/sbin/sed -i -r "s/(pam_ck_connector\.so)(.*)nox11(.*)$/\1\2\3/" /etc/pam.d/system-login',
	}

	file { '/etc/kde':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/kde/startup':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/kde/shutdown':
		ensure => 'directory',
		backup => false,
		owner => 'root',
		mode => '0755',
	}

	file { '/etc/kde/startup/10-agent-startup.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/kde/10-agent-startup.sh',
	}

	file { '/etc/kde/shutdown/10-agent-shutdown.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0755',
		source => 'puppet:///modules/kde/10-agent-shutdown.sh',
	}

	File['/etc/kde'] ->
	File['/etc/kde/startup'] ->
	File['/etc/kde/shutdown'] ->
	File['/etc/kde/startup/10-agent-startup.sh'] ->
	File['/etc/kde/shutdown/10-agent-shutdown.sh']
}
