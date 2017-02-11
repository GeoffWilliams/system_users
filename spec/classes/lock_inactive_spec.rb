require 'spec_helper'

describe 'system_users::lock_inactive' do
  context 'with default values for all parameters' do
    it { should contain_class('system_users::lock_inactive') }
  end
end
