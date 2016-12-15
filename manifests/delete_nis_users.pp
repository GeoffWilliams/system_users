# System_users::Delete_nis_users
#
# Remove all NIS users (identified by lines starting with '+' in /etc/passwd)
# from the system.
class system_users::delete_nis_users {

  file_line { 'delete NIS users from /etc/passwd':
    ensure            => absent,
    path              => '/etc/passwd',
    match_for_absence => true,
    match             => '^\+',
    multiple          => true,
  }
}
