@test 'test nuroot alias created in /etc/passwd' {
  grep ^nuroot: /etc/passwd
}

@test 'test nuroot alias created in /etc/shadow' {
  grep ^nuroot: /etc/shadow
}

@test 'test nuroot2 alias created in /etc/passwd' {
  grep ^nuroot2: /etc/passwd
}
