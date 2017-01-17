@test 'alias nuroot user gone from /etc/passwd' {
  ! grep ^nuroot: /etc/passwd
}

@test 'alias nuroot user gone from /etc/shadow' {
  ! grep ^nuroot: /etc/shadow
}

@test 'alias nuroot2 user gone from /etc/passwd' {
  ! grep ^nuroot2: /etc/passwd
}
