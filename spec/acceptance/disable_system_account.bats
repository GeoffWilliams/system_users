@test "exempt user left alone" {
    awk -F: '/^exempt/ { print $7}' /etc/passwd | grep bash
}

@test "nonexempt user has fixed shell" {
    awk -F: '/^nonexempt/ { print $7}' /etc/passwd | grep nologin
}