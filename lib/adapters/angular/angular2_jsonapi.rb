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

          sample_model =  model.classify.constantize.new
          serializer_type = "#{model}_serializer".classify.constantize
          serializer = serializer_type.new(sample_model)

          associations = serializer.associations.map{ |assoc| assoc.name.to_s }
          associations += serializer.forced_relationships if serializer_type.method_defined? :forced_relationships
          associations.each do |assoc|
            relationship = assoc
            relataionship_types = "_#{relationship.singularize.classify}"
            if serializer_type.method_defined? "#{assoc}_types".to_sym
              types = serializer.send("#{assoc}_types").map { |type| type.to_s }
              relataionship_types =  types.map { |type| "_#{type}" }.join(" | ")
              types.each do |t|
                model_imports << "import { _#{t.singularize.classify} } from 'models/machine/_#{t.singularize}.model';"
              end
            else
              model_imports << "import { _#{relationship.singularize.classify} } from 'models/machine/_#{relationship.singularize}.model';"
            end

            relation = is_singular?(relationship) ? "@BelongsTo" : "@HasMany"
            model_relationships << "  #{relation}(#{serialized_name(relationship)})\n" +
                "  #{relationship.camelize(:lower)}: #{relataionship_types};"

          end

          if serializer_type.method_defined? :private_attributes
            serializer.private_attributes.each do |attr|
              push_attributes << attr
            end
          end

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

        File.write("#{output}/models/index.ts", exports.join("\n"))

        erb_template("datastore.ts.erb",
                     "#{output}/services/datastore.ts",
                     { :models => data_store_models.join(",\n"),
                       :imports => "import { #{data_store_imports.join(",\n#{' ' * 9}")} } from 'models';",
                       :api_url => JsonapiModels.configuration.api_url,
                       :api_version => JsonapiModels.configuration.api_version })

      end

      def is_singular?(str)
        str.singularize == str
      end

      def serialized_name(key)
        key.include?("_") ? "{ serializedName: '#{underscore(key)}' }" : ""
      end

    end
  end
end