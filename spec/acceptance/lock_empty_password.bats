@test 'nopasswd user locked password in /etc/shadow' {
  grep '^nopasswd:!!:' /etc/shadow
}
