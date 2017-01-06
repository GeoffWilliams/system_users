@test 'nis users gone from /etc/passwd' {
  grep -v ^+ /etc/passwd
}

@test 'nis users gone from /etc/group' {
  grep -v ^+ /etc/group
}

@test 'nis users gone from /etc/shadow' {
  grep -v ^+ /etc/shadow
}
