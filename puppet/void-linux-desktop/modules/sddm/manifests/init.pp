# Install sddm.
class sddm {
	class { 'sddm::package': }
	class { 'sddm::config': }
	class { 'sddm::service': }

	Class['kde'] ->
	Class['sddm::package'] ->
	Class['sddm::config'] ->
	Class['sddm::service']
}
