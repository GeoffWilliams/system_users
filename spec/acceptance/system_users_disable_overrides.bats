@test 'shosts disabled' {
  [[ $(find /home /exports -name '.shosts' -not -perm 000 | wc -l) -eq 0 ]]
}

@test 'rhosts disabled' {
  [[ $(find /home /exports -name '.rhosts' -not -perm 000 | wc -l) -eq 0 ]]
}

@test 'forward disabled' {
  [[ $(find /home /exports -name '.forward' -not -perm 000 | wc -l) -eq 0 ]]
}

@test 'netrc disabled' {
  [[ $(find / -name '.netrc' -not -perm 000 | -wc -l) -eq 0 ]]
}
