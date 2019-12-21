define void::sv (
	String $command,
	String $service,
) {
	exec { "sv ${title}":
		command => "/sbin/sv ${command} ${service} || /bin/true",
	}
}
