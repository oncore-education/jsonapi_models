module JsonapiModels
  module TemplateHelper

    def not_comment?(line)
      index = line.index(/\S/)
      return true if index.nil?
      line[index] != "#"
    end

    def templates

    end

    def erb_template(source, destination, config)
      source_content = File.read( File.expand_path("../../generators/templates/ng/#{source}", __FILE__) )
      template = ERB.new(source_content).result(binding)

      if destination.index('/')
        path = destination[0..(destination.rindex('/')-1)]
        Dir.mkdir(path) unless Dir.exist?(path) || path == ".."
      end
      File.write(destination, template)
    end

  end
end
