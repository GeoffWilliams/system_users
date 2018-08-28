[![Build Status](https://travis-ci.org/GeoffWilliams/system_users.svg?branch=master)](https://travis-ci.org/GeoffWilliams/system_users)
# system_users

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module provides various classes for locking down local users on a system in order to set password policies, remove invalid users, etc.  The other main feature of the module is to provide a fact called `user_audit` that includes information about all local users, any suspicious files they possess and details of users breaking various aspects of the login system integrity such as duplicated or mismatched UIDs or GIDs.

The `user_audit` fact is structured as follows:

```javascript
"user_audit": {
  "empty_password": [],         // array of users who have empty passwords
  "low_uids": [],               // array of 'low uid' users (UID < 500)
  "system_uids": [],            // array of 'system' users (UID < 1000) 
  "homedirs": {                 // home directory information for each user (only one shown for clarity)
    "root": {
      "path": "/root",
      "ensure": "directory",
      "owner": "root",
      "group": "root",
      "mode": "0550",
      "og_write": []            // array of other/group writable dotfiles in the top level directory
    },
  },
  "local_users": {              // user ID information for all local users (only one shown for clarity, password info on RHEL/Solaris only)
    "root": {
      "uid": "0",
      "gid": "0",
      "comment": "root",
      "home": "/root",
      "shell": "/bin/bash",
      "last_change_days": "17207",
      "change_allowed_days": "0",
      "must_change_days": "99999",
      "warning_days": "7",
      "expires_days": "",
      "disabled_days": ""
    },
  },
  "duplicate": {
    "uid": [],                // array of duplicated UIDs
    "username": [],           // array of duplicated usernames
    "gid": [],                // array of duplicated GIDs
    "groupname": [],          // array of duplicated groupnames
    "root_alias": []          // array of duplicated root users (UID==0)
  }
},
```


## Usage

Most classes will need to be loaded using the `class` resource syntax in order to pass the appropriate class defaults, eg:

```puppet
class { "foo:bar":
  param1 => "value1",
  param2 => "value2",
}
```

Parameters, where available, are documented inside the individual classes.  See [Reference section](#reference).

## Limitations
* AIX 6.1/7.1, RHEL 6/7, Solaris 10 only
* Not supported by Puppet, Inc.

## Development

PRs accepted :)

## Testing
This module supports testing using [PDQTest](https://github.com/GeoffWilliams/pdqtest).


Test can be executed with:

```
bundle install
bundle exec pdqtest all
```

See `.travis.yml` for a working CI example
