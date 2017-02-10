# System_users::Lock_inactive
#
# Lock users who have been inactive for a certain period
#
# @param period How long to wait before locking a user (days)
class system_users::lock_inactive($period = 30) {

# SOLARIS
# if [ ! -f /usr/sadm/defadduser ]; then
#  echo "Default inactivity lockout not set."
#  echo "Run useradd -D -f 35 to create the file"
#  exit 1
# fi
# x=`grep defi nact /usr/sadm/defadduser` 2>&1 if [ $? -ne 0 ]; then
# echo "Default lockout variable not set."
# echo "Run useradd -D -f 35 to set the lockout to 35 days" exit 1
# fi
# y=`echo $x | sed -e 's/.*=//'`
# if [ $y -ne 35 ]; then
#  echo "Default lock variable set to $y."
# echo "Run useradd -D -f 35 to set the lockout to 35 days" fi

# ALSO NEED TO PROCESS ETC SHADOW
# /bin/cp /etc/shadow /etc/shadow.$$
# /bin/ed /etc/shadow.$$ << END
# 1,/nobody4/d
# w
# q
# END
# /bin/cat /etc/shadow.$$ | while : ; do
#  x=`line`
#  if [ "$x" = "" ]; then
# break fi
#   num=`echo $x | cut -f7 -d":"`
#   user=`echo $x | cut -f1 -d":"`
#  if [ "$num" = "" ]; then
#   echo "User $user lockout not set"
#  else
# if [ $num -ne 35 ]; then
# echo "User $user lockout set to $num instead of 35."
# fi fi
# done


  # rhel
  file_line { "lock inactive users":
    ensure => present,
    match  => 'INACTIVE=',
    path   => '/etc/default/useradd',
    line   => "INACTIVE=${period}",
  }
}
