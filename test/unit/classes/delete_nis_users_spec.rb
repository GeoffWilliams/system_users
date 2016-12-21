#require 'spec_helper'
require 'henchman/spec_helper'

# all we can really do for this one is check our code compiles
describe 'system_users::delete_nis_users' do
  context 'with default values for all parameters' do
    it { should contain_class('system_users::delete_nis_users') }
  end
end
