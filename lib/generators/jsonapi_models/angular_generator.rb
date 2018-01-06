require 'adapters/jsonapi_models_adapter'
require 'adapters/angular/angular2_jsonapi'

module JsonapiModels
  class AngularGenerator < Rails::Generators::Base
    include JsonapiModels::Adapters

    #source_root File.expand_path("../../templates/ng", __FILE__)

    desc "Add better description here"

    argument :adapter, :type => :string, :default => "angular2_jsonapi"

    def generate
      output = JsonapiModels.configuration.ng_output
      raise Exception.new('ng_output must be specified in initializers/jsonapi_models.rb') if output.nil?

      Angular2JsonApiAdapter.new( output ) if adapter == "angular2_jsonapi"
    end

  end
end