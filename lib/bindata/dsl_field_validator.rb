# Override DSLFieldValidator#ensure_valid_name from bindata/lib/dsl.rb
# gem bindata
# because we should not raise error on duplicate name
module BinData
  module DSLMixin
    class DSLFieldValidator
      def ensure_valid_name(name)
        if name and not option?(:fieldnames_are_values)
          if malformed_name?(name)
            # raise NameError.new("", name), "field '#{name}' is an illegal fieldname"
          end

          if duplicate_name?(name)
            # raise SyntaxError, "duplicate field '#{name}'"
          end

          if name_shadows_method?(name)
            raise NameError.new("", name), "field '#{name}' shadows an existing method"
          end

          if name_is_reserved?(name)
            raise NameError.new("", name), "field '#{name}' is a reserved name"
          end
        end
      end
    end
  end
end
