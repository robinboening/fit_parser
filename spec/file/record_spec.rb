require 'spec_helper'

describe FitParser::File::Record do
  describe '#read' do
    context 'given a sample definition record' do
      it 'works' do
        record = described_class.new({})
        file = example_file('record/definition_record')
        record.read(file)
        expect(record.header).to be_a(FitParser::File::RecordHeader)
        expect(record.content).to be_a(FitParser::File::Definition)
      end
    end

    context 'given a sample data record with a string non null terminated' do
      context 'string length is equal to field size' do
        it 'works' do
          record = described_class.new({})
          record.read(example_file('record/definition_record_2.fit'))
          definitions = record.definitions
          file = example_file('record/data_record_2.fit')
          record = described_class.new(definitions).read(file)
          expect(record.header).to be_a(FitParser::File::RecordHeader)
          expect(record.content.raw_version).to eql(250)
          expect(record.content.raw_part_number).to eql('123-A1234-00')
        end
      end

      context 'string length is smaller than field size' do
        it 'works' do
          record = described_class.new({})
          record.read(example_file('record/definition_record_2.fit'))
          definitions = record.definitions
          file = example_file('record/data_record_2bis.fit')
          record = described_class.new(definitions).read(file)
          expect(record.header).to be_a(FitParser::File::RecordHeader)
          expect(record.content.raw_version).to eql(251)
          expect(record.content.version).to eql(2.51)
          expect(record.content.raw_part_number).to eql('123-A1234')
          expect(record.content.part_number).to eql('123-A1234')
        end
      end
    end
  end
end
