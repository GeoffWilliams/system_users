# System_users::Delete_nis_users
#
# Remove all NIS users (identified by lines starting with '+' in /etc/passwd)
# from the system.
class system_users::delete_nis_users {

  File_line {
    ensure            => 'absent',
    match_for_absence => true,
    match             => '^\+',
    multiple          => true,
  }

  file_line { 'delete NIS users from /etc/passwd':
    path  => '/etc/passwd',
  }

  file_line { 'delete NIS users from /etc/shadow':
    path => '/etc/shadow',
  }

  file_line { 'delete NIS users from /etc/group':
    path => '/etc/group',
  }
}
