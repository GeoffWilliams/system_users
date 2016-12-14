#usermod -g 0 root (group for root user)
#lock inactive users (useradd -D -f 34)
#remove nis + entries
#remove all accounts uid=0 != root
#custom fact - naughty files -- .rhosts, .netrc, .forward
#csutom fact - dup uids gids usernames groups
#lock accounts with no password
module SystemUsers
  module Fact
    def self.add_fact()
      Facter.add(:user_audit) do
        setcode do
          SystemUsers::Fact::run_fact()
        end
      end
    end

    def self.get_dups(filename, col)
      list = File.readlines(filename).map do |line|
        line.split(':')[col]
      end
      # http://stackoverflow.com/a/8922049
      dups = list.group_by{ |e| e }.select { |k, v| v.size > 1 }.map(&:first)
      dups.sort()
    end

    def self.run_fact()
      {
        :duplicate => {
          :uid        => get_dups('/etc/passwd', 2),
          :username   => get_dups('/etc/passwd', 0),
          :gid        => get_dups('/etc/group', 2),
          :groupname  => get_dups('/etc/group', 0)
        }
      }
    end

  end
end


SystemUsers::Fact.add_fact
