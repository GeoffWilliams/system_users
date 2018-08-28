# @summary Lock all user accounts with empty passwords
#
# The `user_audit` fact contains a list of users with empty passwords, we use this to
# determine if any accounts need locking
#
# @param lock_method string to insert into password field to lock the account
class system_users::lock_empty_password($lock_method = '*') {
  $users_to_lock = dig($facts, 'user_audit', 'empty_password')
  if $users_to_lock {
    user { $users_to_lock:
      password => $lock_method,
    }
  }
}
