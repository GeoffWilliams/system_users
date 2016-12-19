require 'json'
module InstallModules
  METADATA_FILE='metadata.json'

  def install
    if File.exists?
      deps = JSON.parse(File.read(metadata_file))['dependencies']
      deps.each { |dep|
        module_id = dep['name']
        vendor    = module_id.split('-')[0]
        name      = module_id.split('-')[1]
        # ignore the version and test the latest
        
        puts "
        
        
      }
    else
      abort("Error: #{METADATA_FILE} does not exist")
    end
  end



