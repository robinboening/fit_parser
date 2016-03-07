module FitParser
  class File
    class Record
      def self.read(io)
        new.read(io)
      end

      def self.clear_definitions!
        @definitions = {}
      end

      def self.definitions=(value)
        @definitions = value
      end

      def self.definitions
        @definitions
      end

      attr_reader :header, :content

      def read(io)
        @header = RecordHeader.read(io)

        @content = case @header.message_type.snapshot
        when 1
          Definition.read(io).tap do |definition|
            Record.definitions[@header.local_message_type.snapshot] = Data.generate(definition)
          end
        when 0
          definition = Record.definitions[@header.local_message_type.snapshot]
          raise "No definition for local message type: #{@header.local_message_type}" if definition.nil?
          definition.read(io)
        end

        self
      end

    end
  end
end
