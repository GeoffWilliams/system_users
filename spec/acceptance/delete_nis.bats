@test "/etc/group entries removed" {
    ! grep '+' /etc/group
}

@test "/etc/gshadow entries removed" {
    ! grep '+' /etc/gshadow
}

@test "/etc/passwd entries removed" {
    ! grep '+' /etc/passwd
}

@test "/etc/shadow entries removed" {
    ! grep '+' /etc/shadow
}