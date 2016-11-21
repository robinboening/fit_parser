module FitParser
  class File
    MSG_NUM_FIELD_DESCRIPTION = 206

    def self.read(io)
      new.read(io)
    end

    attr_reader :header, :records, :crc

    def initialize
      @records = []
    end

    def read(io)
      @header = Header.read(io)
      definitions = {}
      dev_definitions = {}
      while io.pos < @header.end_pos
        record = Record.new(definitions, dev_definitions)
        @records << record.read(io)
        content = record.content
        if content[:global_message_number] == MSG_NUM_FIELD_DESCRIPTION
          field_definition_local_message_type = record.header.local_message_type
        end
        if !content[:global_message_number] && field_definition_local_message_type && record.header.local_message_type == field_definition_local_message_type
          dev_definitions[content[:raw_field_0].to_s] ||= {}
          dev_definitions[content[:raw_field_0].to_s][content[:raw_field_1].to_s] = content
        end
        definitions = record.definitions
      end
      @crc = io.read(2)
      self
    end
  end
end
