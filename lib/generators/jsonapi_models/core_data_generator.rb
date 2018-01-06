module JsonapiModels
  module Generators
    class CoreDataGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Add better description here"

      argument :version, :type => :string, :default => nil

      def generate
        
      end

      private

      def swift_type(type)
        if type.to_s == "datetime" || type.to_s == "date"
          return "Date"
        elsif type.to_s == "integer"
          return "Int"
        elsif type.to_s == "float"
          return "Float"
        end

        type
      end

    end
  end
end