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
        if record.content[:raw_field_0] == 0
          content = record.content
          dev_definitions[content[:raw_field_0].to_s] = { content[:raw_field_1].to_s => content }
        end
        definitions = record.definitions
      end
      @crc = io.read(2)
      self
    end
  end
end
