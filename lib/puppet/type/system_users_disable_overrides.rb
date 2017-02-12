require 'puppet/parameter/boolean'

Puppet::Type.newtype(:system_users_disable_overrides) do
  @doc = "Disable the files .netrc, .forward, .rhosts and .shosts by changing the owner to root and the permissions to 000"

  newproperty(:ensure) do
    newvalue(:overrides_disabled) do
      return provider.disable_overrides
    end
  end

  # also create ensure as a parameter to stop puppet complaining about
  # missing namevars/titles.  The validation code here never seems to
  # be executed - which kinda makes sense because it looks like the
  # property setter overrides this once its in play.  I was hoping to
  # have the model disable multiple uses of this custom type since its
  # basically a switch but this seems impossible.  Instead:
  # "Don't do that" (TM)
  newparam(:ensure) do
    # The code below never fires.  I'l leave it in place incase anyone
    # works out a way to enable it
    # validate do |value|
    #   if value != 'overrides_disabled'
    #     raise ArgumentError, "system_users_disable_overrides only accepts ensure => overrides_disabled"
    #   end
    # end
    isnamevar
  end
end
