module FitParser
  class File
    class Record
      attr_reader :header, :content, :definitions

      def initialize(definitions)
        @definitions = definitions
      end

      def read(io)
        @header = RecordHeader.read(io)

        @content = case @header.message_type.snapshot
        when 1
          Definition.read(io).tap do |definition|
            @definitions[@header.local_message_type.snapshot] = Data.generate(definition)
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
