module Rubyamf
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include Rails::Generators::Migration
      
      source_root File.expand_path("../../templates", __FILE__)
      
      argument :attributes, 
               :type => :array, 
               :default => [], 
               :banner => "Usage: rubyamf:scaffold ModelName [field:type, field:type]"
      
      class_option :orm, :banner => "NAME", :type => :string, 
                                            :required => true, 
                                            :desc => "ORM to generate controller for"
      
      def create_controller
        template 'controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
      end
      
      def create_model
        template 'model.rb', File.join('app/models', "#{singular_name}.rb")
      end
            
      def copy_migration
        migration_template "migration.rb", "db/migrate/create_#{plural_name}.rb"
      end
      
      hook_for :template_engine, :test_framework, :as => :scaffold
      
      protected
      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
      
    end
  end
end