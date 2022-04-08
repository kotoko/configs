class pipewire {
  class { 'pipewire::package': }
  class { 'pipewire::config': }

  Class['pipewire::package'] ->
  Class['pipewire::config']
}