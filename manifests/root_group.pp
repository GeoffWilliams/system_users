# System_users::root_group
#
# Set the group for the `root` user to be GID 0
class system_users::root_group {
  user { "root":
    gid => 0,
  }
}
