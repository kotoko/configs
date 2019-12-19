define void::sv (
	String $command,
	String $service,
) {
	exec { "sv ${title}":
		cwd => '/root',
		command => "/sbin/sv ${command} ${service} || /bin/true",
	}
}
