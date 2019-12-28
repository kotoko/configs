class kde::config {
	# Remove 'nox11' (from pam config) from line with 'pam_ck_connector.so'.
	exec { 'sed_system-login':
		command => '/sbin/sed -i -r "s/(pam_ck_connector\.so)(.*)nox11(.*)$/\1\2\3/" /etc/pam.d/system-login',
	}

	$dirs = [
		'/etc/xdg',
		'/etc/xdg/plasma-workspace',
		'/etc/xdg/plasma-workspace/env',
		'/etc/xdg/plasma-workspace/shutdown',
	]

	$dirs.each |String $dir| {
		file { $dir:
			ensure => 'directory',
			owner => 'root',
			mode => '0755',
		}
	}

	file { '/etc/xdg/plasma-workspace/env/10-agent-startup.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/kde/10-agent-startup.sh',
	}

	file { '/etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/kde/10-agent-shutdown.sh',
	}

	File['/etc/xdg'] ->
	File['/etc/xdg/plasma-workspace'] ->
	File['/etc/xdg/plasma-workspace/env'] ->
	File['/etc/xdg/plasma-workspace/shutdown'] ->
	File['/etc/xdg/plasma-workspace/env/10-agent-startup.sh'] ->
	File['/etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh']
}
