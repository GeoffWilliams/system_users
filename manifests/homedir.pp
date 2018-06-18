# System_users::Homedir
#
# Check and fix common gotchas in user homedirs on this system:
#
class system_users::homedir(
    $mode = unset,
) {
  $homedirs = dig($facts, 'user_audit', 'homedirs')

  if $homedirs {
    # skip system uids as these users often share vital system directories
    # between themselves such as /sbin, /, /var/lib, etc...
    $homedirs.filter |$user, $hash| {
      ! $user in $facts['user_audit']['system_uids'] and
      $user != "root" and
      ! (
        $hash['path'] =~ /^\/bin/ or
        $hash['path'] =~ /^\/boot/ or
        $hash['path'] =~ /^\/dev/ or
        $hash['path'] =~ /^\/etc/ or
        $hash['path'] =~ /^\/lib/ or
        $hash['path'] =~ /^\/media/ or
        $hash['path'] =~ /^\/mnt/ or
        $hash['path'] =~ /^\/opt/ or
        $hash['path'] =~ /^\/proc/ or
        $hash['path'] =~ /^\/run/ or
        $hash['path'] =~ /^\/sbin/ or
        $hash['path'] =~ /^\/srv/ or
        $hash['path'] =~ /^\/sys/ or
        $hash['path'] =~ /^\/tmp/ or
        $hash['path'] =~ /^\/usr/ or
        $hash['path'] =~ /^\/var/
      )
    }.each |$user, $hash| {

      file { $hash['path']:
        ensure => directory,
        owner  => $user,
        mode   => $mode,
      }
    }
  }
}
