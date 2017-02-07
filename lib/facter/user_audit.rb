#usermod -g 0 root (group for root user)
#lock inactive users (useradd -D -f 34)
#remove nis + entries
#remove all accounts uid=0 != root
#custom fact - naughty files -- .rhosts, .netrc, .forward
#csutom fact - dup uids gids usernames groups
#lock accounts with no password
require 'puppetx/system_users_constants'

module SystemUsers
  module Fact
    def self.add_fact()
      Facter.add(:user_audit) do
        setcode do
          SystemUsers::Fact::run_fact()
        end
      end
    end

    def self.root_aliases
      list = File.readlines(SystemUsersConstants::PASSWD_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = (line =~ /^\s*$/).is_a?(Fixnum)or (line =~ /^#/).is_a?(Fixnum)

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
        reject = (line =~ /^\s*$/).is_a?(Fixnum) or (line =~ /^#/).is_a?(Fixnum)
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

    def self.run_fact()
      {
        :duplicate => {
          :uid        => get_dups(SystemUsersConstants::PASSWD_FILE, 2),
          :username   => get_dups(SystemUsersConstants::PASSWD_FILE, 0),
          :gid        => get_dups(SystemUsersConstants::GROUP_FILE, 2),
          :groupname  => get_dups(SystemUsersConstants::GROUP_FILE, 0),
          :root_alias => root_aliases(),
        },
        :empty_password => empty_password(),
      }
    end

  end
end


SystemUsers::Fact.add_fact
