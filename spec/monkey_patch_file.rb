# for testing purposes, we need to monkey patch File.chown() to always
# work since we don't run our tests as root.  I wanted to be able to
# use rspec-mocks for this but it seems that the puppetlabs_spec_helper
# forces rspec to use mocha which then gives us an undefined method when
# we go to use the allow() function:
#
#   allow(FakeFS::File).to receive(:chown).and_return(true)
#
# I have no idea how to fix this or even if its fixable.  Skipping the
# spec helper of-course breaks all other puppet tests.  I think the only
# other option would be a separate rake task with a different helper but
# I'm putting this firmly in the too-hard basket
module MonkeyPatch

  def self.on()
    $stderr.puts "MonkeyPatching file >>>>>>>>>>>>>"
    FakeFS::File.class_eval do
      @fake_chowns = {}

      def self.chown(owner_int, group_int, filename)
        @fake_chowns[filename] = [owner_int, group_int]
        $stderr.puts "running monkey patched File.chown -- chmod(#{owner_int}, #{group_int}, #{filename})"
      end

      # return a hash of the fake chmods we did
      def self.get_fake_chowns
        @fake_chowns
      end

    end
  end
end
