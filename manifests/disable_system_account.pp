# System_users::Disable_system_accounts
#
# Lock the shell of low uid (<500) system accounts present on this node
# excluding root
class system_users::disable_system_account {
  dig($facts,'user_audit','low_uids').then |$users| {
    $users.each |$user| {
      if $user in ["sync", "shutdown", "halt"] {
        $shell = undef
      } else {
        $shell = "/sbin/nologin"
      }


      user { $user:
        password => "*",
        shell    => $shell,
      }
    }
  }
}
