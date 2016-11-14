module FitParser
  class File
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
        if content[:raw_field_0] == 0
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
