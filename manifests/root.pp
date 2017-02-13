# System_users::Root
#
# Ensure root user and its homedir are setup correctly
#
class system_users::root {
  user { "root":
    ensure => present,
    uid    => 0,
    gid    => 0,
    home   => "/root",
  }

  file { "/root":
    ensure => directory,
    mode   => "0700",
    owner  => "root",
    group  => "root",
  }
}
