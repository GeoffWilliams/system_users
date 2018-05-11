#usermod -g 0 root (group for root user)
#lock inactive users (useradd -D -f 34)
#remove nis + entries
#remove all accounts uid=0 != root
#custom fact - naughty files -- .rhosts, .netrc, .forward
#csutom fact - dup uids gids usernames groups
#lock accounts with no password
require 'puppetx/system_users_constants'
require 'etc'
module SystemUsers
  module Fact
    def self.add_fact()
      Facter.add(:user_audit) do
        setcode do
          SystemUsers::Fact::run_fact()
        end
      end
    end

    def self.get_uids(max)
      list = File.readlines(SystemUsersConstants::PASSWD_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = !!(line =~ /^\s*$/ or line =~ /^\s*#/)

        # skip IDs >= 500 leaving only the low ones
        reject |= line.split(':')[3].to_i >= max

        # skip root
        reject |= line.split(':')[0] == 'root'

        reject
      }.map { |line|
        line.split(':')[0]
      }.uniq.sort
    end

    def self.low_uids
      get_uids(500)
    end

    def self.system_uids
      get_uids(1000)
    end


    def self.root_aliases
      list = File.readlines(SystemUsersConstants::PASSWD_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = !!(line =~ /^\s*$/ or line =~ /^\s*#/)

        # only for UID == 0 (root power)
        reject |= line.split(':')[2] != '0'

        # skip root
        reject |= line.split(':')[0] == 'root'

        reject
      }.map { |line|
        line.split(':')[0]
      }.uniq.sort
    end

    def self.get_dups(filename, col)
      list = File.readlines(filename).reject { |line|
        # skip entirely whitespace or commented out
        line =~ /^\s+$/ or line =~ /^#/
      }.map { |line|
        line.split(':')[col]
      }

      # http://stackoverflow.com/a/8922049
      dups = list.group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)
      dups.sort()
    end

    # Return a hash of usernames and homedirs for use later
    def self.homedirs()
      data = {}
      File.readlines(SystemUsersConstants::PASSWD_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = !!(line =~ /^\s*$/ or line =~ /^\s*#/)
      }.each { |line|
        # Fact to contain structured data representing the homedir
        # "don" => {
        #   path => "/home/don",
        #   ensure  => directory,
        #   owner   => "don",
        #   group   => "don",
        #   mode    => "0700",
        # },
        # "mon" => {
        #   path => /home/mon,
        #   ensure  => absent,
        #   owner   => nil,
        #   group   => nil,
        #   mode    => nil,
        # }
        user = line.split(':')[0]
        path  = line.split(':')[5]
        if File.exists?(path)
          if File.symlink?(path)
            type = "link"
          elsif Dir.exists?(path)
            type = "directory"
          else
            type = "file"
          end

          # we may not be able to resolve the UID to a name if we're inside a
          # testcase or things are really broken os just print the UID/GID
          stat  = File.stat(path)
          mode  = "%04o" % (stat.mode & 0777)

          # UID/user
          begin
            owner = Etc.getpwuid(stat.uid).name
          rescue ArgumentError
            owner = stat.uid
          end

          # GID/group
          begin
            group = Etc.getpwuid(stat.gid).name
          rescue ArgumentError
            owner = stat.gid
          end

          # find any world/group writable files in the top level homedir, do NOT
          # perform a complete find as this will take too much resources
          og_write = Dir.glob(File.join(path, "*"), File::FNM_DOTMATCH).reject { |f|
            rej = (f =~ /^\.{1,2}$/)
            if ! rej
              stat = File.stat(f)
              rej = ! ((stat.mode & 00002) == 00002) and ! ((stat.mode & 00020) == 00020)
            end

            rej
          }
        else
          type      = "absent"
          owner     = nil
          group     = nil
          mode      = nil
          og_write  = nil
        end
        data[user] = {
          "path"      => path,
          "ensure"    => type,
          "owner"     => owner,
          "group"     => group,
          "mode"      => mode,
          "og_write"  => og_write,
        }
      }

      data
    end

    # AIX handles passwords differently to regular solaris and linux boxes - it
    # has a custom shadow file at /etc/security/passw in its own format.
    # Recommended method to check for empty passwords was `pwdck -n ALL`
    # however this seems to return a list of every userid problem *except* for
    # empty passwords.
    # The file has the format below.  In this case user matt has a locked
    # password whereas user geoff is configured to allow access with no password
    #
    #   matt:
    #     password = *
    #     lastupdate = 1478218258
    #
    #   geoff:
    #      password =
    #
    #
    # Therefore, to find empty passwords, we just need to look for /password =\s+$/
    # and read the line before it
    def self.empty_password_aix()
      bad_users = []
      current_user = false
      File.readlines(SystemUsersConstants::SHADOW_FILE_AIX).each { |line|
        if line =~  /^\w+:\s*$/
          current_user = line.tr(": \n",'')
        elsif line =~ /^\s+password\s*=\s*$/
          bad_users << current_user
        end
      }

      bad_users
    end

    def self.empty_password_regular()
      list = File.readlines(SystemUsersConstants::SHADOW_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = !!(line =~ /^\s*$/ or line =~ /^\s*#/)
        reject |= line.split(':')[1] != ''

        reject
      }.map { |line|
        line.split(':')[0]
      }

      list
    end

    def self.empty_password()
      if Facter.value(:os)['family'] == 'AIX'
        bad_users = empty_password_aix
      else
        bad_users = empty_password_regular
      end

      bad_users
    end

    # representation of all users in /etc/passwd
    def self.local_users()
      data = {}
      File.readlines(SystemUsersConstants::PASSWD_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = !!(line =~ /^\s*$/ or line =~ /^\s*#/)

        reject
      }.each { |line|
        fields = line.strip.split(':')

        data[fields[0]] = {
          "uid"     => fields[2],
          "gid"     => fields[3],
          "comment" => fields[4],
          "home"    => fields[5],
          "shell"   => fields[6],
        }

      }

      # if NOT on AIX, read the shadow file and figure out password validity (
      # AIX has its own crazy format and there's no requirement to deal with it
      # right now)
      if Facter.value(:os)['family'] != 'AIX'
        File.readlines(SystemUsersConstants::SHADOW_FILE).reject { |line|
          # skip entirely whitespace or commented out
          reject = !!(line =~ /^\s*$/ or line =~ /^\s*#/)

          reject
        }.each { |line|
          fields = line.strip.split(':')

          if data.include?(fields[0])
            data[fields[0]]["last_change_days"]     = fields[2]
            data[fields[0]]["change_allowed_days"]  = fields[3]
            data[fields[0]]["must_change_days"]     = fields[4]
            data[fields[0]]["warning_days"]         = fields[5]
            data[fields[0]]["expires_days"]         = fields[6]
            data[fields[0]]["disabled_days"]        = fields[7]
          end
        }
      end

      data
    end

    def self.run_fact()
      {
        :empty_password => empty_password(),
        :low_uids       => low_uids(),
        :system_uids    => system_uids(),
        :homedirs       => homedirs(),
        :local_users    => local_users(),
        :duplicate      => {
          :uid        => get_dups(SystemUsersConstants::PASSWD_FILE, 2),
          :username   => get_dups(SystemUsersConstants::PASSWD_FILE, 0),
          :gid        => get_dups(SystemUsersConstants::GROUP_FILE, 2),
          :groupname  => get_dups(SystemUsersConstants::GROUP_FILE, 0),
          :root_alias => root_aliases(),
        },
      }
    end

  end
end


SystemUsers::Fact.add_fact
