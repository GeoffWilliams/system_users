# System_users::Disable_system_accounts
#
# Lock the password and shell of:
#   system users (`system_uids` - uid < 1000)
#   - or -
#   low uid users (`low_uids` - uid < 500)
#
# For system accounts present on this node excluding:
#   * root
#   * sync (password lock only)
#   * shutdown (password lock only)
#   * halt (password lock only)
#
# You can exclude particular usernames from the above requirement with the `exempt_users`
# parameter. This should be used if you want to leave particular users alone. The action
# of locking the password and shell is guarded to try to avoid clashes with other catalog
# resources. For this to work, you need to evaluate this class _after_ any other user
# resources that should take precidence.
#
# The data on users in the UID range is sourced from the `user_audit` fact which ships inside this module. The fact
# itself excludes the root user.
#
# @param uid_range Range of UIDs to lockdown (see above)
# @param exempt_users Exempt any usernames in this list from lockdown
class system_users::disable_system_account(
    Enum['low_uids', 'system_uids'] $uid_range      = 'system_uids',
    Array[String]                   $exempt_users = [],
) {
  dig($facts,'user_audit', $uid_range).then |$users| {
    $users.filter |$user| {
      ! member($exempt_users, $user)
    }.each |$user| {
      if $user in ["sync", "shutdown", "halt"] {
        $shell = undef
      } else {
        $shell = "/sbin/nologin"
      }

      if ! defined(User[$user]) {
        user { $user:
          password => "*",
          shell    => $shell,
        }
      }
    }
  }
}
