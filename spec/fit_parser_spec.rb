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
      %w(
        be470628-c34a-4189-aae3-42bef36436ce.fit
        fc84b277-68af-4d63-ac8d-fb8e162ab2a2.fit
        ).each do |file|
        threads << Thread.new(file) do |el|
          data = FitParser.load_file("spec/support/examples/file/#{el}")
          expect(data.records).to_not be_nil
        end
      end
      threads.each { |thread| thread.join }
    end

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

  it 'works without threads' do
    path = 'spec/support/examples/file/fc84b277-68af-4d63-ac8d-fb8e162ab2a2.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  #context 'garmin fenix with IQ datafields' do
  #  it 'works' do
      # path = 'spec/support/examples/1375670253.fit'
  #    path = 'spec/support/examples/1379311720.fit'
  #    data = FitParser.load_file(path)
  #    expect(data.records).to_not be_nil
  #  end
  #end
end
