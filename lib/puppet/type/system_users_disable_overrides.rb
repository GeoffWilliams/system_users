require 'puppet/parameter/boolean'

Puppet::Type.newtype(:system_users_disable_overrides) do
  @doc = "SCP a file"

  ensurable do
    desc "Create or remove the scp'ed file"
    defaultvalues
    defaultto(:present)
  end
end
