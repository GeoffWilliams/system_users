@test 'nis users gone from /etc/passwd' {
  ! grep '^+' /etc/passwd
}

@test 'nis users gone from /etc/group' {
  ! grep '^+' /etc/group
}

@test 'nis users gone from /etc/shadow' {
  ! grep '^+' /etc/shadow
}
