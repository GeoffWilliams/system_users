@test 'root gid is set to 2 for test' {
  [ $(id -g root) -eq 2 ]
}
