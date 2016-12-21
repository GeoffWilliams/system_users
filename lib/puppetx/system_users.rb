module PuppetX
  module SystemUsers
    PASSWD_FILE = '/etc/passwd'
    FILES_TO_DISABLE = [
      '.forward',
      '.netrc',
      '.rhosts'
    ]


    # find the home directories in use on this system by looking for unique
    # directories in /etc/passwd
    def self.get_homedirs()
      if File.exists?(PASSWD_FILE)
        list = File.readlines(PASSWD_FILE).reject { |line|
          line =~ /^\s+$/ or line =~ /^#/
        }.map do |line|
          # skip entirely whitespace or commented out
          line.split(':')[5]
        end
        list.uniq.sort
      else
        raise "#{PASSWD_FILE} file not found"
      end
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
