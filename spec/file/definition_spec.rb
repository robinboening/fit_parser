require 'spec_helper'

describe FitParser::File::Definition do
  context 'given a sample definition message' do
    describe '.read' do
      subject do
        described_class.read example_file('record/message/definition')
      end

      its(:architecture) { should == 0 }
      its(:global_message_number) { should == 0 }
      its(:field_count) { should == 6 }
      it { expect(subject.fields_arr.size).to eq(subject.field_count) }

      its(:record_type) { should == :definition }
      it 'returns the real type for fields' do
        expect(subject.fields_arr[0].real_type).to be == :uint32z
        expect(subject.fields_arr[1].real_type).to be == :date_time
        expect(subject.fields_arr[2].real_type).to be == :manufacturer
        expect(subject.fields_arr[3].real_type).to be == :uint16 # product
        expect(subject.fields_arr[4].real_type).to be == :uint16 # number
        expect(subject.fields_arr[5].real_type).to be == :file
      end
    end
  end
end
