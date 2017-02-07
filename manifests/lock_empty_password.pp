# System_users::Lock_empty_password
#
# Lock all user accounts with empty passwords
#
# @param lock_method string to insert into password field to lock the account
class system_users::lock_empty_password($lock_method = '*') {
  $users_to_lock = dig($facts, 'user_audit', 'empty_password')
  if $users_to_lock {
    user { $users_to_lock:
      password => $lock_method,
    }
  } else {
    warning("user_audit fact missing - system_users module seems broken?")
  }
}
