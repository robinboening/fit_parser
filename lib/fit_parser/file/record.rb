module FitParser
  class File
    class Record
      attr_reader :header, :content, :definitions

      def initialize(definitions, dev_definitions)
        @definitions = definitions
        @dev_definitions = dev_definitions
      end

      def read(io)
        @header = RecordHeader.read(io)

        @content = case @header.message_type.snapshot
        when 1
          Definition.read(io, { dev_data_flag: @header.dev_data_flag }).tap do |definition|
            if @header.dev_data_flag == 1
              @definitions[@header.local_message_type.snapshot] = Data.generate(definition, @dev_definitions)
            else
              @definitions[@header.local_message_type.snapshot] = Data.generate(definition)
            end
          end
        when 0
          definition = @definitions[@header.local_message_type.snapshot]
          fail "No definition for local message type: #{@header.local_message_type}" if definition.nil?
          definition.read(io)
        end

        self
      end
    end
  end
end
