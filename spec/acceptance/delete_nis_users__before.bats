@test 'test nis users exist in /etc/passwd' {
  grep ^+ /etc/passwd
}

@test 'test nis users exist in /etc/group' {
  grep ^+ /etc/group
}

@test 'test nis users exist in /etc/shadow' {
  grep ^+ /etc/shadow
}
