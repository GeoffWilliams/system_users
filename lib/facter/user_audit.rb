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

    def self.run_fact()
      'abcdef'
    end

  end
end


SystemUsers::Fact.add_fact
