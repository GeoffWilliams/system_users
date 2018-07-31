#@PDQTest
class { "system_users::disable_system_account":
  exempt_users => ['exempt'],
}