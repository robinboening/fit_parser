module FitParser
  class File
    class Type
      def self.types
        @types ||= {}
      end

      def self.types=(value)
        @types = value
      end

      def self.get_type(name)
        return Type.types[name] if Type.types.key?(name)
        type = Types.get_type_definition name
        Type.types[name] = type ? new(type) : nil
      end

      def initialize(type)
        @type = type
      end

      def value(val)
        return nil unless valid?(val)
        if @type.key?(:method)
          Types.send(@type[:method], val, @type[:values], @type[:parameters])
        else
          values = @type[:values]
          value = values[val] if values
          return value unless value.nil?
          val
        end
      end

      private

      def valid?(val)
        if @type.key?(:invalid)
          invalid_value = @type[:invalid]
        else
          invalid_value = Types.get_type_definition(@type[:basic_type])[:invalid]
        end
        return false if val == invalid_value
        true
      end
    end
  end
end
