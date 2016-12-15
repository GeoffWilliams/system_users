require 'puppet/parameter/boolean'

Puppet::Type.newtype(:system_users_disable_overrides) do
  @doc = "Disable the files .netrc, .forward, .rhosts by changing the owner to root and the permissions to 000"

  newproperty(:ensure) do
    newvalue(:overrides_disabled) do
      return provider.disable_overrides
    end
  end

  newparam(:name) do
    desc "The name of the database."
  end


#   #ensurable do
#   #  desc "Ensure overrides are disabled (true) or unaltered (false)"
#
#     newvalue(:true) do
# #      provider.install
#     end
#
#     newvalue(:false) do
# #      provider.uninstall
#     end
#
#     defaultto :false
#   end

  #def insync?(is)
#    puts "insnyc force false"
  #  return false
  #end
end
