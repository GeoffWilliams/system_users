# --- first run ---
@test 'package is installed' {
  rpm -q nmap-ncat
}

@test 'exec ran before package' {
  grep "package nmap-ncat is not installed" /tmp/exec.txt
}

@test 'second exec ran' {
  ls /tmp/demo.txt
}


