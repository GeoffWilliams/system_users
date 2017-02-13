require 'spec_helper'

# all we can really do for this one is check our code compiles
describe 'system_users::root_group' do
  context "catalog compiles" do
    it { should compile}
  end
  
  context 'with default values for all parameters' do
    it { should contain_class('system_users::root_group') }

    it {
      is_expected.to contain_user('root').with(
        {
          :gid => 0,
        }
      )
    }
  end
end
