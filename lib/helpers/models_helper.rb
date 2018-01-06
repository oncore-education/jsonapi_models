module JsonapiModels
  module ModelsHelper

    def underscore(key)
      key.gsub("_", "-")
    end

    def all_models
      Dir[Rails.root.join("app/models/**/*.rb")].map do |file|
        file.split("/").last.split(".").first
      end
    end

  end
end
