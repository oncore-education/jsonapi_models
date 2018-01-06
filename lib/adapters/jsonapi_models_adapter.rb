require 'helpers/models_helper'
require 'helpers/template_helper'
require 'helpers/type_helper'
require 'erb'
require 'bundler/vendor/thor/lib/thor'
require 'bundler/vendor/thor/lib/thor/base'
require 'bundler/vendor/thor/lib/thor/actions'

module JsonapiModels
  module Adapters
    class JsonapiModelsAdapter
      include JsonapiModels::TemplateHelper
      include JsonapiModels::ModelsHelper
      include JsonapiModels::TypeHelper

      attr_accessor :models,
                    :output

      def initialize(output)
        self.models = all_models
        self.output = output

        generate
      end

      def generate

      end

    end
  end
end