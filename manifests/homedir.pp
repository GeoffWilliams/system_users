# @summary Ensure user homedirs set to correct `mode`
#
# The `user_audit` fact contains a list of all homedirs for users local to this system. We
# use this information to enforce the desired mode on these directories, excluding the `root`
# user and other system home directories (see code for details).
#
# @note The `mode` parameter must be set for any changes to happen.
#
# @param mode Mode to set home directories to, eg `0700`
class system_users::homedir(
    Optional[String] $mode = undef,
) {
  $homedirs = dig($facts, 'user_audit', 'homedirs')

  if $homedirs and $mode {
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
