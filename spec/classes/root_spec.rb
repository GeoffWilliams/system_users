require 'spec_helper'

describe 'system_users::root' do
  context "catalog compiles" do
    it { should compile}
  end

  context 'with default values for all parameters' do
    it { should contain_class('system_users::root') }
  end
end
