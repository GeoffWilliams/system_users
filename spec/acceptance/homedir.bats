@test "showoff homedir created" {
  ls /home/showoff
}

@test "gil homedir created" {
  ls /home/gil
}

@test "ftp homedir NOT created (lowuid)" {
  ! test -d /var/ftp
}
