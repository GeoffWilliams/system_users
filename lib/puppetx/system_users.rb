module PuppetX
  module SystemUsers
    FILES_TO_DISABLE = [
      '.forward',
      '.netrc',
      '.rhosts'
    ]


    # find the home directories in use on this system by looking for unique
    # directories in /etc/passwd
    def self.get_homedirs()
      list = File.readlines('/etc/passwd').reject { |line|
        line =~ /^\s+$/ or line =~ /^#/
      }.map do |line|
        # skip entirely whitespace or commented out
        line.split(':')[5]
      end
      list.uniq.sort
    end

    def self.get_targets()
      targets = []
      get_homedirs().each { |homedir|
        FILES_TO_DISABLE.each { |f|
          munged_filename = File.join(homedir, f)

          if File.exists?(munged_filename)
            stat = File.stat(munged_filename)
            if stat.uid != 0
              targets.push(munged_filename)
            elsif ("%03o" % (stat.mode & 0777)) != '000'
              targets.push(munged_filename)
            end
          end
        }
      }
      targets.sort
    end

    # called to update the system if changes are needed
    def self.disable_overrides()
      get_targets().each { |f|
        # (concurrency) check the file didn't vanish after we found it
        # (correctness) make sure we munged the target correctly
        if File.exists?(f)
          Puppet.notice("Disabling #{f}")
          File.chown(0, nil, f)
          File.chmod(0000, f)
        else
          Puppet.notice("Requested lockdown of file #{f} but it does not exist")
        end
      }
      return :overrides_disabled
    end

  end
end
