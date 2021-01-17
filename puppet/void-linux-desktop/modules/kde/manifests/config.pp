class kde::config {
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
