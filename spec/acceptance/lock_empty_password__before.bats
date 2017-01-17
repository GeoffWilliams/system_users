@test 'nopasswd user has no password in /etc/shadow' {
  grep '^nopasswd::' /etc/shadow
}
