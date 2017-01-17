@test 'root gid is zero' {
  [ $(id -g root) -eq 0 ]
}
