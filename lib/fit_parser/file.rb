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
      while io.pos < @header.end_pos
        record = Record.new(definitions)
        @records << record.read(io)
        definitions = record.definitions
      end
      @crc = io.read(2)
      self
    end
  end
end
