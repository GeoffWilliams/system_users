require 'spec_helper'
require 'facter/user_audit'
require 'fakefs/spec_helpers'

describe SystemUsers::Fact do

  # IMPORTANT - use a fake filesystem for all tests
  include FakeFS::SpecHelpers

  it "work ya bastard" do
    config = File.dirname(File.expand_path(__FILE__)) + '/../fixtures/fakefs/duplicate_username'
    FakeFS::FileSystem.clone(config, '/')
$stdout.puts config
$stdout.puts File.read('/etc/passwd')
    expect(SystemUsers::Fact.run_fact()).to eq "abcdef"
  end
end
