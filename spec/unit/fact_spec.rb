# test custom fact at lib/facter/user_audit.rb
#require 'henchman/spec_helper'
require 'spec_helper'
require 'facter/user_audit'
# important! must load PP before fakefs - https://github.com/fakefs/fakefs/issues/99
# otherwise fakefs breaks the include function iself ;-)
require 'pp'
require 'fakefs_testcase'
require 'fakefs/spec_helpers'

describe SystemUsers::Fact do

  # IMPORTANT - use a fake filesystem for all tests.  We load a different whole
  # filesystem from fixtures/fakefs for each test we run
  include FakeFS::SpecHelpers

  #
  # /etc/passwd
  #
  it "duplicate uid detected" do
    FakeFSTestcase.activate_testcase('duplicate_uid')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:uid]).to eq ['1','6']
  end
  #
  it "duplicate username detected" do
    FakeFSTestcase.activate_testcase('duplicate_username')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:username]).to eq ['daemon', 'dupuser']
  end

  #
  # /etc/group
  #
  it "duplicate gid detected" do
    FakeFSTestcase.activate_testcase('duplicate_gid')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:gid]).to eq ['1002','1003']
  end

  it "duplicate groupname detected" do
    FakeFSTestcase.activate_testcase('duplicate_groupname')

    expect(SystemUsers::Fact.run_fact()[:duplicate][:groupname]).to eq ['apache', 'dupgroup']
  end

  it "root alias detected" do
    FakeFSTestcase.activate_testcase('root_alias')
    expect(SystemUsers::Fact.run_fact()[:duplicate][:root_alias]).to eq ['nuroot']
  end

  it "empty password detected" do
    FakeFSTestcase.activate_testcase('empty_password')
    expect(SystemUsers::Fact.run_fact()[:empty_password]).to eq ['nopasswd']
  end

  it "empty password detected on aix" do
    FakeFSTestcase.activate_testcase('aix_empty_password')
    expect(SystemUsers::Fact.empty_password_aix()).to eq ['nopasswd']
  end

  it "finds the low UIDs correctly" do
    FakeFSTestcase.activate_testcase('low_uids')
    expect(SystemUsers::Fact.low_uids()).to eq [
      "adm",
      "bin",
      "daemon",
      "dbus",
      "ftp",
      "games",
      "halt",
      "lp",
      "mail",
      "nobody",
      "operator",
      "shutdown",
      "sshd",
      "sync",
      "systemd-network",
      "tss",
    ]
  end

  it "processes homedirs correctly" do
    FakeFSTestcase.activate_testcase('homedirs')

    # files in FakesFS are always 644 no matter what the host filesystem says,
    # however, we can chmod before running our test to create the world writable
    # file.  For some reason, files beginning '.' are not readable in the fact
    # when on fakefs, however on the system the exact same layout works fine.
    # This is as good as I can get it.
    File.chmod(0777, "/home/showoff/vb")


    homedirs = SystemUsers::Fact.homedirs()

    expect(homedirs["root"]['path']).to eq "/root"
    expect(homedirs["dbus"]['path']).to eq "/"

    # wanted to test for
    stat  = File.stat('/home/showoff/vb')
    mode  = "%04o" % (stat.mode & 0777)
    expect(homedirs["showoff"]['og_write'][0]).to eq "/home/showoff/vb"

  end
end
