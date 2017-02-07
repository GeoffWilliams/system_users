# System_users::Delete_root_alias
#
# Remove all aliases of the root account (UID == 0 and username != root)
class system_users::delete_root_alias {
  # user { $user_audit['duplicate']['root_alias']:
  #   ensure => absent,
  # }
  $users_to_delete = dig($facts, 'user_audit', 'duplicate', 'root_alias')

  if $users_to_delete {
    $users_to_delete.each |$remove_user| {
      # remove from /etc/passwd
      augeas { "remove root alias from passwd ${remove_user}":
        changes => "rm /files/etc/passwd/${remove_user}/",
      }

      # remove from /etc/shadow - will also fire if
      augeas { "remove root alias from shadow ${remove_user}":
        changes => "rm /files/etc/shadow/${remove_user}/",
      }
    }
  }
}
