# test type and provider at lib/puppet/type/system_users_disable_overrides.rb
require 'spec_helper'
require 'find'
tut = Puppet::Type.type(:system_users_disable_overrides)

# important! must load PP before fakefs - https://github.com/fakefs/fakefs/issues/99
# otherwise fakefs breaks the include function iself ;-)
require 'pp'
require 'fakefs/spec_helpers'
describe tut do
  # IMPORTANT - use a fake filesystem for all tests.  We load a different whole
  # filesystem from fixtures/fakefs for each test we run
  #
  include FakeFS::SpecHelpers

  config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/disable_overrides'
  targets_before = []
  Find.find(config) { |f|
    list = []
    if f =~ /.netrc/ or f =~ /.forward/ or f =~ /.rhosts/
      targets_before.push(f.sub(config,''))
    end
    targets_before.sort!
  }

  let :params do
    [
      :ensure,
    ]
  end

  let :properties do
    [
      :ensure,
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(tut.properties.map(&:name)).to be_include(property)
    end
  end

  it 'should disable access to override files' do
    # build a list of files that should be GONE after our provider runs.  We
    # *must* run this before activating fakefs or we won't be able to read them!



    FakeFS::FileSystem.clone(config, '/')

    targets_before.each do |f|
      if File.exists?(f)

        # check each file owned by root with permissions '000'
        stat  = File.stat(f)
        uid   = stat.uid
        mode  = "%o" % (stat.mode & 0777)


        expect(uid).to eq 0
        expect(mode).to eq '000'
      else
        msg ="File #{f} not present in tests - suspect broken test code"
        fail msg
      end
    end
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
