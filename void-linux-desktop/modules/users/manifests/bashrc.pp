class users::bashrc (
	Array[Tuple[String, String]] $users,
) {

	# Configuration for normal users
	$users.each |Tuple[String, String] $u| {
		$user = $u[0]
	  [
			["/home/${user}/.bashrc", 'puppet:///modules/users/bash/bashrc'],
			["/home/${user}/.bash_aliases", 'puppet:///modules/users/bash/bash_aliases'],
			["/home/${user}/.bash_git_integration", 'puppet:///modules/users/bash/bash_git_integration'],
			["/home/${user}/.dir_colors", 'puppet:///modules/users/bash/dir_colors'],
			["/home/${user}/.git-prompt-colors.sh", 'puppet:///modules/users/bash/git-prompt-colors.sh'],
			["/home/${user}/.screenrc", 'puppet:///modules/users/bash/screenrc'],
		].each |Tuple[String, String] $f| {
			file { $f[0]:
				ensure => 'file',
				backup => false,
				owner => $user,
				group => $user,
				mode => '0644',
				source => $f[1],
			}
		}
	}

	# Configuration for root
	[
		["/root/.bashrc", 'puppet:///modules/users/bash/bashrc'],
		["/root/.bash_aliases", 'puppet:///modules/users/bash/bash_aliases'],
		["/root/.bash_git_integration", 'puppet:///modules/users/bash/bash_git_integration'],
		["/root/.dir_colors", 'puppet:///modules/users/bash/dir_colors'],
		["/root/.git-prompt-colors.sh", 'puppet:///modules/users/bash/git-prompt-colors.sh'],
		["/root/.screenrc", 'puppet:///modules/users/bash/screenrc'],
	].each |Tuple[String, String] $f| {
		file { $f[0]:
			ensure => 'file',
			backup => false,
			owner => 'root',
			group => 'root',
			mode => '0644',
			source => $f[1],
		}
	}

	# Configuration for new accounts created in future
	[
		["/etc/skel/.bashrc", 'puppet:///modules/users/bash/bashrc'],
		["/etc/skel/.bash_aliases", 'puppet:///modules/users/bash/bash_aliases'],
		["/etc/skel/.bash_git_integration", 'puppet:///modules/users/bash/bash_git_integration'],
		["/etc/skel/.dir_colors", 'puppet:///modules/users/bash/dir_colors'],
		["/etc/skel/.git-prompt-colors.sh", 'puppet:///modules/users/bash/git-prompt-colors.sh'],
		["/etc/skel/.screenrc", 'puppet:///modules/users/bash/screenrc'],
	].each |Tuple[String, String] $f| {
		file { $f[0]:
			ensure => 'file',
			backup => false,
			owner => 'root',
			group => 'root',
			mode => '0644',
			source => $f[1],
		}
	}
}