# System_users::Lock_empty_password
#
# Lock all user accounts with empty passwords
#
# @param lock_method string to insert into password field to lock the account
class system_users::lock_empty_password($lock_method = '!!') {

  user { $user_audit['empty_password']:
    password => $lock_method
  }
}
