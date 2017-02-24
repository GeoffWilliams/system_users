# System_users::Lock_inactive
#
# Lock users who have been inactive for a certain period
#
# @param period How long to wait before locking a user (days)
class system_users::lock_inactive($period = 30) {

  # SOLARIS
  case $facts['os']['family'] {
    "Solaris" : {
      $defaults_file  = "/usr/sadm/defadduser"
      $exec_title     = "rebuild ${defaults_file}"

      file {$defaults_file:
        ensure => present,
        owner  => "root",
        group  => "root",
        mode   => "0600",
      }
      file_line { "${defaults_file} definact":
        ensure => present,
        path   => $defaults_file,
        line   => "definact=${period}",
        match  => "^definact=",
        notify => Exec[$exec_title]
      }
      exec { $exec_title:
        command     => "useradd -D",
        refreshonly => true,
        path        => ["/usr/sbin", "/sbin", "/usr/bin", "/bin"],
      }
    }
    "RedHat": {
      # rhel
      file_line { "lock inactive users":
        ensure => present,
        match  => 'INACTIVE=',
        path   => '/etc/default/useradd',
        line   => "INACTIVE=${period}",
      }
    }
    default: {
      fail("class ${name} does not support ${facts['os']['family']}")
    }
  }
}
