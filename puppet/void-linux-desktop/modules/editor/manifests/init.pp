# Set variable EDITOR (default program for editing text files in terminal).
class editor {
  file { '/etc/profile.d/editor.sh':
		ensure => 'file',
		backup => false,
		owner => 'root',
		mode => '0644',
		source => 'puppet:///modules/editor/editor.sh',
	}
}
