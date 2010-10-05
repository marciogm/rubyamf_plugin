module Rubyamf
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../rails_installer_files", __FILE__)
      
      def copy_crossdomain
        if !File.exists?('/public/crossdomain.xml')
          copy_file "../../rails_installer_files/crossdomain.xml", "config/crossdomain.xml"
        end
      end
      
      def copy_config
       if !File.exists?('/config/rubyamf_config.rb')
         copy_file "../../rails_installer_files/rubyamf_config.rb", "config/rubyamf_config.rb"
       end
      end
      
      def copy_controller
        if !File.exists?('/controllers/rubyamf_controller.rb')
          copy_file "../../rails_installer_files/rubyamf_controller.rb", "controllers/rubyamf_controller.rb"
        end
      end
      
      def copy_helper
        if !File.exists?('/helpers/rubyamf_helper.rb')
          copy_file "../../rails_installer_files/rubyamf_helper.rb", "controllers/rubyamf_helper`.rb"
        end
      end
      
      def inject_mime_types
        mime = true
        mime_types_file_exists = File.exists?('/config/initializers/mime_types.rb')
        mime_config_file = mime_types_file_exists ? '/config/initializers/mime_types.rb' : './config/environment.rb'
        
        File.open(mime_config_file, "r") do |f|
          while line = f.gets
            if line.match(/application\/x-amf/)
              mime = false
              break
            end
          end
        end
        
        if mime
          File.open(mime_config_file,"a") do |f|
            f.puts "\nMime::Type.register \"application/x-amf\", :amf"
          end
        end
      end
      
      def inject_routes
        route_amf_controller = true
        
        #fosrias: Add version correct route
        File.open('./config/routes.rb', 'r') do |f|
          while  line = f.gets
            if line.match("map.rubyamf_gateway 'rubyamf_gateway', :controller => 'rubyamf', :action => 'gateway") &&
               Rails::VERSION::MAJOR < 3 || line.match("match 'rubyamf/gateway', :to => 'rubyamf#gateway'")  #Rails 3 route
              route_amf_controller = false
              break
            end
          end
        end

        if route_amf_controller
          routes = File.read('./config/routes.rb')
          routes_regexp =  Rails::VERSION::MAJOR < 3 ? /(ActionController::Routing::Routes.draw do \|map\|)/ : /(Application.routes.draw do)/
          updated_routes = routes.gsub(routes_regexp) do |s|
            if  Rails::VERSION::MAJOR < 3
              "#{$1}\n  map.rubyamf_gateway 'rubyamf_gateway', :controller => 'rubyamf', :action => 'gateway'\n"
            else
               "#{$1}\n  match 'rubyamf/gateway', :to => 'rubyamf#gateway'\n"  #Rails 3 route
            end
          end
          File.open('./config/routes.rb', 'w') do |file|
            file.write updated_routes
          end
        end
        #fosrias
      end
      
      def show_readme
        readme "../templates/USAGE" if behavior == :invoke
      end
      
    end
  end
end