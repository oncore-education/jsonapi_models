module JsonapiModels
  module Adapters
    class Angular2JsonApiAdapter < JsonapiModelsAdapter

      def generate
        exports = []
        data_store_models = []
        data_store_imports = []
        models.each do |model|
          serializer_file = "app/serializers/#{model}_serializer.rb"
          next unless File.exist?(serializer_file)

          exports << "export * from 'models/#{model}.model';"
          data_store_models << "    #{model.pluralize}: #{model.classify}"
          data_store_imports << model.classify

          push_attributes = []
          model_imports = []
          model_relationships = []
          model_attributes = []
          File.open(serializer_file, "r") do |f|
            f.each_line do |line|
              if not_comment?(line)
                relation = nil
                if line.include?("has_many")
                  relation = "@HasMany"
                elsif line.include?("belongs_to")
                  relation = "@BelongsTo"
                end

                if relation.present?
                  line = line.split("#").first.strip
                  relationship = line.split(":").last.squish
                  model_relationships << "  #{relation}(#{serialized_name(relationship)})\n" +
                      "  #{relationship.camelize(:lower)}: #{relationship.singularize.classify};"
                  model_imports << "import { #{relationship.singularize.classify} } from 'models/#{relationship.singularize}.model';"
                end
              end

              if line.include?("#push_attr")
                push_attributes << line.split(" ").last.squish
              end
            end

            sample_model =  model.classify.constantize.new
            serializer = "#{model}_serializer".classify.constantize.new(sample_model)

            types = model.classify.constantize.columns.map { |col| [col.name.to_sym, ng_type(col.type)] }.to_h
            serializer.attributes.each do |key, value|
              key = key.to_s
              next if key == "id"
              model_attributes << "  @Attribute(#{serialized_name(key)})\n" +
                  "  #{key.camelize(:lower)}: #{types[key.to_sym]};"
            end

            if !push_attributes.empty?
              model_attributes << "  //Private Push Only Attributes"
              push_attributes.each do |attr|
                a = attr.split(":")
                key = a[0]
                type = a[1]
                model_attributes << "  @Attribute(#{serialized_name(key)})\n" +
                    "  #{key.camelize(:lower)}: #{type};"
              end
            end

            model_destination = "#{output}/models/#{model}.model.ts"
            unless File.exist?(model_destination)
              erb_template("model.ts.erb",
                           model_destination,
                           { :model => model,
                             :classname => model.classify })
            end

            erb_template("machine_model.ts.erb",
                         "#{output}/models/machine/_#{model}.model.ts",
                         { :type => model.pluralize,
                           :file => "models/#{model}.model.ts",
                           :attributes => model_attributes.join("\n\n"),
                           :relationships => model_relationships.join("\n\n"),
                           :imports => model_imports.join("\n"),
                           :classname => model.classify })
          end

        end

        File.write("#{output}/models/index.ts", exports.join("\n"))


        erb_template("datastore.ts.erb",
                     "#{output}/services/datastore.ts",
                     { :models => data_store_models.join(",\n"),
                       :imports => "import { #{data_store_imports.join(",\n#{' ' * 9}")} } from 'models';",
                       :api_url => JsonapiModels.configuration.api_url,
                       :api_version => JsonapiModels.configuration.api_version })

      end


      def serialized_name(key)
        key.include?("_") ? "{ serializedName: '#{underscore(key)}' }" : ""
      end

    end
  end
end