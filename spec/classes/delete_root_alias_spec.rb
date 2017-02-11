require 'spec_helper'

describe 'system_users::delete_root_alias' do
  context 'with default values for all parameters' do
    it { should contain_class('system_users::delete_root_alias') }
  end
end
