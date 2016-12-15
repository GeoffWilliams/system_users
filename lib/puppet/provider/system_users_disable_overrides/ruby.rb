require 'puppetx/system_users.rb'
Puppet::Type.type(:system_users_disable_overrides).provide(:ruby) do
  desc 'Support for Puppet running Docker Compose'

  # called to update the system if changes are needed
  def disable_overrides()
    PuppetX::SystemUsers.disable_overrides()
    return :overrides_disabled
  end

  # Called to see if this resource needs to update
  def ensure
    if PuppetX::SystemUsers.get_targets().empty?
      # no targets identified - system doesn't need changes
      current_status = :overrides_disabled
    else
      # we need to disable some dodgy files
      current_status = :needs_overrides_disabled
    end
    return current_status
  end
end
