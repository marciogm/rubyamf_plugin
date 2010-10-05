require 'fileutils'

if !File.exist?('./config/rubyamf_config.rb')	
  FileUtils.copy_file("./vendor/plugins/rubyamf_plugin/rails_installer_files/rubyamf_config.rb", "./config/rubyamf_config.rb", false)
end