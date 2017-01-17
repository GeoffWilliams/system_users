#usermod -g 0 root (group for root user)
#lock inactive users (useradd -D -f 34)
#remove nis + entries
#remove all accounts uid=0 != root
#custom fact - naughty files -- .rhosts, .netrc, .forward
#csutom fact - dup uids gids usernames groups
#lock accounts with no password
module SystemUsers
  module Fact
    PASSWD_FILE = '/etc/passwd'
    GROUP_FILE  = '/etc/group'
    SHADOW_FILE = '/etc/shadow'

    def self.add_fact()
      Facter.add(:user_audit) do
        setcode do
          SystemUsers::Fact::run_fact()
        end
      end
    end

    def self.root_aliases
      list = File.readlines(PASSWD_FILE).reject { |line|
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

    def self.empty_password()
      list = File.readlines(SHADOW_FILE).reject { |line|
        # skip entirely whitespace or commented out
        reject = (line =~ /^\s*$/).is_a?(Fixnum) or (line =~ /^#/).is_a?(Fixnum)
        reject |= line.split(':')[1] != ''

        reject
      }.map { |line|
        line.split(':')[0]
      }

      list
    end

    def self.run_fact()
      {
        :duplicate => {
          :uid        => get_dups(PASSWD_FILE, 2),
          :username   => get_dups(PASSWD_FILE, 0),
          :gid        => get_dups(GROUP_FILE, 2),
          :groupname  => get_dups(GROUP_FILE, 0),
          :root_alias => root_aliases(),
        },
        :empty_password => empty_password(),
      }
    end

  end
end


SystemUsers::Fact.add_fact
