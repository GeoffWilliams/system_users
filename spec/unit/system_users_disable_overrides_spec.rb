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

  # before(:example) do
  #   allow(FakeFS::File).to receive(:chown).and_return(true)
  # end

  it 'should disable access to override files initialized in before(:example)' do
    # build a list of files that should be GONE after our provider runs.  We
    # *must* run this before activating fakefs or we won't be able to read them!
    # mylib = PuppetX::SystemUsers
    # FakeFS::activate!
    FakeFS::FileSystem.clone(config, '/')

    MonkeyPatch.on()
    # File.chown('/etc/passwd',nil,nil)
    # stat  = File.stat('/etc/passwd')
    # uid   = stat.uid
    # puts uid
    # File.chmod(0000, '/etc/passwd')
    # puts "still here"
    #allow(File).to receive(:find_x).and_return({something: 'testing'})
    $stdout.puts "<<<<<<< entry"
    $stdout.puts "<<<<<<< stioll here"
    #PuppetX::SystemUsers
    PuppetX::SystemUsers.disable_overrides()
$stdout.puts ">>>>>>>>>>>> disable overrides call completed"
    targets_before.each do |f|
      if File.exists?(f)

        # check each file owned by root with permissions '000'
      stat  = File.stat(f)
      uid   = stat.uid
        mode  = "%03o" % (stat.mode & 0777)
        puts mode
        puts "*************************"
        #File.expects(:chmod).with(0000, f)
        #File.expects(:chown).with(0, nil, f)
      #expect(uid).to eq 0
        expect(mode).to eq '000'

        # expect that we did a fake chown to uid 0
        expect(File.get_fake_chowns()[f]).to eq [0, nil]
      else
        msg ="File #{f} not present in tests - suspect broken test code"
        fail msg
      end
    end

    # stub the Fakefs File class to allow chmod to succeed
    #FakeFS::File.stub(:chown).and_return(true)

#http://stackoverflow.com/questions/24520798/stub-static-module-method-on-controller

#allow(FakeFS::File).to receive(:chown).and_return(true)
    #::File.stub(:chown).with(anything).and_return true




  end

  # it 'should have expected parameters' do
  #   params.each do |param|
  #     expect(compose.parameters).to be_include(param)
  #   end
  # end
  #
	# it 'should require options to be a string' do
	# 	expect(compose).to require_string_for('options')
  # end
  #
	# it 'should require up_args to be a string' do
	# 	expect(compose).to require_string_for('up_args')
  # end
  #
	# it 'should require scale to be a hash' do
	# 	expect(compose).to require_hash_for('scale')
  # end
end
