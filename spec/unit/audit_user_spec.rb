# test custom fact at lib/facter/user_audit.rb
require 'spec_helper'
require 'facter/user_audit'

# important! must load PP before fakefs - https://github.com/fakefs/fakefs/issues/99
# otherwise fakefs breaks the include function iself ;-)
require 'pp'
require 'fakefs/spec_helpers'
describe SystemUsers::Fact do

  # IMPORTANT - use a fake filesystem for all tests.  We load a different whole
  # filesystem from fixtures/fakefs for each test we run
  include FakeFS::SpecHelpers

  #
  # /etc/passwd
  #
  it "duplicate uid detected" do
    config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/duplicate_uid'
    FakeFS::FileSystem.clone(config, '/')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:uid]).to eq ['1','6']
  end

  it "duplicate username detected" do
    config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/duplicate_username'
    FakeFS::FileSystem.clone(config, '/')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:username]).to eq ['daemon', 'dupuser']
  end

  #
  # /etc/group
  #
  it "duplicate gid detected" do
    config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/duplicate_gid'
    FakeFS::FileSystem.clone(config, '/')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:gid]).to eq ['1002','1003']
  end

  it "duplicate groupname detected" do
    config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/duplicate_groupname'
    FakeFS::FileSystem.clone(config, '/')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:groupname]).to eq ['apache', 'dupgroup']
  end

end
