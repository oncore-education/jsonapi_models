module JsonapiModels
  #module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates JsonapiModels initializer for your application"

      def copy_initializer
        template "jsonapi_models_initializer.rb", "config/initializers/jsonapi_models.rb"

        puts "All your json models are belong to us"
      end
    end
  #end
end