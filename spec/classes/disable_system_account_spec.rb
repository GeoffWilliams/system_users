require 'spec_helper'

describe 'system_users::disable_system_account' do
  context "catalog compiles" do
    it { should compile}
  end
  
  context 'with default values for all parameters' do
    it { should contain_class('system_users::disable_system_account') }
  end

  context 'low_uids processed correctly' do
    let :facts do
      {
        :user_audit => {
          "low_uids" => ["shutdown", "bin"]
        }
      }
    end

    let :params do
      {
          :uid_range => "low_uids",
      }
    end

    # shutdown should not have its shell changed but should be locked
    it { should contain_user("shutdown").with(
      {
        :password => "*",
        :shell    => nil,
      }
    )}

    # all other low UIDs should be locked with a disabled shell
    it { should contain_user("bin").with(
      {
        :password => "*",
        :shell    => "/sbin/nologin",
      }
    )}
  end

end
