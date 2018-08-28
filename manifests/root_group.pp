# @summary Set the group for the `root` user to be GID 0
#
# Manage the `gid` of the `root` user and nothing else
#
# @note incompatible with `system_users::root`
class system_users::root_group {
  user { "root":
    gid => 0,
  }
}
