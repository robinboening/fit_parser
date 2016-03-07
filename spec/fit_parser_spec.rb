require 'spec_helper'

describe FitParser do
  describe 'VERSION' do
    subject{ FitParser::VERSION }

    it { is_expected.to be_a(String) }
    it { is_expected.to match(/\d{1,2}\.\d{1,2}\.\d{1,2}/) }
  end

  describe '.load_file' do
    it 'works with threads' do
      threads = []
      %w(3863374146 3110334490).each do |file|
        threads << Thread.new(file) do |el|
          data = FitParser.load_file("spec/support/examples/file/#{el}")
          expect(data.records).to_not be_nil
        end
      end
      threads.each { |thread| thread.join }
    end
  end
end
