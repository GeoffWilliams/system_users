# test type and provider at lib/puppet/type/system_users_disable_overrides.rb
require 'rspec/mocks'
require 'spec_helper'
require 'find'
require 'puppetx/system_users'
require 'monkey_patch_file'

# important! must load PP before fakefs - https://github.com/fakefs/fakefs/issues/99
# otherwise fakefs breaks the include function iself ;-)
require 'pp'
require 'fakefs/spec_helpers'

describe PuppetX::SystemUsers do
  # use a fake filesystem for all tests.  We load a different whole
  # filesystem from fixtures/fakefs for each test we run
  #
  include FakeFS::SpecHelpers

  config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/disable_overrides'

  # The files our type and provider should disable
  targets_before = []
  Find.find(config) { |f|
    list = []
    if f =~ /.netrc/ or f =~ /.forward/ or f =~ /.rhosts/
      targets_before.push(f.sub(config,''))
    end
    targets_before.sort!
  }

  let :title do
    "disable_overrides"
  end

  it 'should disable access to override files initialized in before(:example)' do
    # build a list of files that should be GONE after our provider runs.  We
    # *must* run this before activating fakefs or we won't be able to read them!
    # mylib = PuppetX::SystemUsers
    # FakeFS::activate!
    FakeFS::FileSystem.clone(config, '/')

    # Monkey patch the FakeFS::File class to have a chown function that
    # always succeeds.  Rely on rspec to reset this after each test - in
    # reality it doesn't matter (in this instance...) since we're the only
    # ones doing chown...
    MonkeyPatch.on()
    PuppetX::SystemUsers.disable_overrides()
    targets_before.each do |f|
      if File.exists?(f)
        stat  = File.stat(f)

        # expect that our chmod removed all permissions
        mode  = "%03o" % (stat.mode & 0777)
        expect(mode).to eq '000'

        # expect that we did a fake chown to uid 0
        expect(File.get_fake_chowns()[f]).to eq [0, nil]
      else
        msg ="File #{f} not present in tests - suspect broken test code"
        fail msg
      end
    end
  end

end
