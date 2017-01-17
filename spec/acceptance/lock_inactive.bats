@test 'inactive directive added to /etc/default/useradd' {
  grep 'INACTIVE=30' /etc/default/useradd
}
