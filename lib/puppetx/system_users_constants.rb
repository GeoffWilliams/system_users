module SystemUsersConstants
  PASSWD_FILE       = '/etc/passwd'
  GROUP_FILE        = '/etc/group'
  SHADOW_FILE       = '/etc/shadow'
  SHADOW_FILE_AIX   = '/etc/security/passwd'
  FILES_TO_DISABLE  = [
    '.forward',
    '.netrc',
    '.rhosts',
    '.shosts',
  ]

end
