module JsonapiModels
  module TypeHelper

    def ng_type(type)
      if type.to_s == "datetime" || type.to_s == "date"
        return "Date"
      elsif type.to_s == "integer" || type.to_s == "float"
        return "number"
      elsif type.to_s == "text"
        return "string"
      end

      type
    end

  end
end


