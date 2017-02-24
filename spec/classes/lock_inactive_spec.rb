require 'spec_helper'

describe 'system_users::lock_inactive' do
  let :facts do
    {
      :os => {
        "family" => "RedHat"
      }
    }
  end

  context "catalog compiles" do
    it { should compile}
  end

  context 'with default values for all parameters' do
    it { should contain_class('system_users::lock_inactive') }
  end
end
