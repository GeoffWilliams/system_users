# System_users::Lock_inactive
#
# Lock users who have been inactive for a certain period
#
# @param period How long to wait before locking a user (days)
class system_users::lock_inactive($period = 30) {
  file_line { "lock inactive users":
    ensure => present,
    match  => 'INACTIVE=',
    path   => '/etc/default/useradd',
    line   => "INACTIVE=${period}",
  }
}
