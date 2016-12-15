Puppet::Type.type(:system_users_disable_overrides).provide(:ruby) do
  desc 'Support for Puppet running Docker Compose'
  FILES_TO_DISABLE = [
    '.forward',
    '.netrc',
    '.rhosts'
  ]


  # find the home directories in use on this system by looking for unique
  # directories in /etc/passwd
  def get_homedirs()
    list = File.readlines('/etc/passwd').map do |line|
      line.split(':')[5]
    end
    list.uniq.sort
  end

  def get_targets()
    targets = []
    get_homedirs().each { |homedir|
      FILES_TO_DISABLE.each { |f|
        munged_filename = File.join(homedir, f)

        if File.exists?(munged_filename)
          stat = File.stat(munged_filename)
          if stat.uid != 0
            targets.push(f)
          elsif ("%03o" % (stat.mode & 0777)) != '000'
            targets.push(munged_filename)
          end
        end
      }
    }
    targets.sort
  end

  # called to update the system if changes are needed
  def disable_overrides()
    get_targets().each { |f|
      Puppet.notice("Disabling #{f}")
      File.chown(0, nil, f)
      File.chmod(0000, f)
    }
    return :overrides_disabled
  end

  # Called to see if this resource needs to update
  def ensure
    if get_targets().empty?
      # no targets identified - system doesn't need changes
      current_status = :overrides_disabled
    else
      # we need to disable some dodgy files
      current_status = :needs_overrides_disabled
    end
    return current_status
  end
end
