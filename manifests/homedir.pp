# System_users::Homedir
#
# Check and fix common gotchas in user homedirs on this system:
#
class system_users::homedir {
  $homedirs = $facts['user_audit']['homedirs']
  $homedirs.filter |$user, $hash| {
    ! $user in $facts['user_audit']['low_uids'] and
    $user != "root" and
    ! $hash['path'] in ["/", "/bin", "/usr/bin", "/usr/sbin", "/sbin", "/dev/null"]
  }.each |$user, $hash| {
    # do not attempt permission corrections as doing so may trash the system.
    # Also, skip low uids as these users often share vital system directories
    # between themselves such as /sbin, /, /var/lib, etc...
    $res = {
      $hash['path'] => {
        "ensure" => "directory",
        "owner"  => $user,
      }
    }
    ensure_resources("file", $res)

    # }
#  SOL10X_96	Check User Dot File Permissions
  }
}
