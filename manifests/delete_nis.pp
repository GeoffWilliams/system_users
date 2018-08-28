# @summary Delete _legacy_ NIS users from this system
#
# Delete _legacy_ NIS users from this system (lines starting `+` in `/etc/group`, `/etc/gshadow`, `/etc/passwd` and
# `/etc/shadow`).
#
# @see https://forge.puppet.com/geoffwilliams/filemagic
#
# @example Remove all `+` entries
#   include system_users::delete_nis
class system_users::delete_nis {
  fm_replace { ["/etc/group", "/etc/gshadow", "/etc/passwd", "/etc/shadow"]:
    ensure => absent,
    match  => "^\\+",
  }
}