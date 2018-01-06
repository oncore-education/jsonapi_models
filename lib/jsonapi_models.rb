require "jsonapi_models/version"

module JsonapiModels
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :ng_output,
                  :ios_data_model,
                  :ios_output,
                  :api_url,
                  :api_version

    def initialize
      @ng_output = nil
      @ios_data_model = nil
      @ios_output = nil
      @api_url = "http://localhost:3000"
      @api_version = "v1"
    end
  end
end
