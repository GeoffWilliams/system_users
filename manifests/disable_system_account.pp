# System_users::Disable_system_accounts
#
# Lock the shell of:
#   system users (`system_uids` - uid < 1000)
#   - or -
#   low uid users (`low_uids` - uid < 500)
#
# For system accounts present on this node excluding:
#   * root
#   * sync
#   * shutdown
#   * halt
#
# The data on users in the UID range is sourced from the `user_audit` fact which ships inside this module. The fact
# itself excludes the root user.
#
# @param uid_range Range of UIDs to lockdown (see above)
class system_users::disable_system_account(
    Enum['low_uids', 'system_uids'] $uid_range = 'system_uids',
) {
  dig($facts,'user_audit', $uid_range).then |$users| {
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
