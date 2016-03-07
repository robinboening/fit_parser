require 'spec_helper'

describe FitParser::File::Type do
  before :all do
    @types = FitParser::File::Types.types
    FitParser::File::Types.add_type(:int_type, :sint8)
    FitParser::File::Types.add_type(
      :int_type_with_val,
      :uint8,
      values: { 1 => 'one', 2 => 'two', 3 => 'three' }
    )
  end

  after :all do
    FitParser::File::Types.types = @types
  end

  describe '.get_type' do
    context 'when valid name' do
      it 'returns a type' do
        expect(described_class.get_type(:int_type))
          .to be_a(FitParser::File::Type)
      end

      it 'returns always the same instance' do
        expect(described_class.get_type(:int_type))
          .to eql(described_class.get_type(:int_type))
      end
    end

    context 'when invalid name' do
      it 'returns nil' do
        expect(described_class.get_type(:unknown_type)).to be_nil
      end
    end
  end

  describe '#value' do
    context 'when type has values' do
      let(:type) { described_class.get_type(:int_type_with_val) }

      context 'known value requested' do
        it 'returns the value' do
          expect(type.value(2)).to eql 'two'
        end
      end

      context 'unknown value requested' do
        it 'returns the input value' do
          expect(type.value(999)).to eql 999
        end
      end

      context 'when invalid value is requested' do
        it 'returns nil' do
          expect(type.value(255)).to be_nil
          expect(type.value(0xFF)).to be_nil
        end
      end
    end

    context 'when type has date_time value' do
      let(:type) { described_class.get_type(:date_time) }
      it 'returns the date' do
        expect(type.value(790_509_304)).to eq('2015-01-18 09:55:04 UTC')
      end
    end

    context 'when type has message_index value' do
      let(:type) { described_class.get_type(:message_index) }

      it 'returns the message_index' do
        expect(type.value(10)).to eq(10)
        expect(type.value(32_778)).to eq(10)
        expect(type.value(28_682)).to eq(10)
      end
    end

    context 'when type has file_flags value' do
      let(:type) { described_class.get_type(:file_flags) }
      it 'returns the file_flags' do
        expect(type.value(10)).to eq('read/erase')
        expect(type.value(0x0A)).to eq('read/erase')
      end
    end

    context 'when type has bool value' do
      let(:type) { described_class.get_type(:bool) }
      it 'returns the boolean value' do
        expect(type.value(0)).to eq(false)
        expect(type.value(1)).to eq(true)
        expect(type.value(255)).to be_nil
      end
    end

    context 'when type has no value' do
      it 'returns nil' do
        type = described_class.get_type(:int_type)
        expect(type.value(1)).to eql 1
      end
    end
  end
end
