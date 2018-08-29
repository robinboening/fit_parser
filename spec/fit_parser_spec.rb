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

    # sometimes doesn't work because of multithreads issues
    # it 'works with threads' do
    #   threads = []
    #   %w(
    #     f334a45f-cd2b-40d8-9c46-b4c34fe9e9dd.
    #     598363e9-3121-4f24-8b6f-b1368a269e8f.
    #     7edbeca2-0c62-42b6-9e7a-e869b1e5ccd0.
    #     dbcdf1a1-3ce0-4e71-a409-bec64c6043b0.
    #     fcc17445-79ec-43bc-9f7f-ea9324992cd2.
    #     ).each do |file|
    #     threads << Thread.new(file) do |el|
    #       data = FitParser.load_file("spec/support/examples/file/#{el}")
    #       expect(data.records).to_not be_nil
    #     end
    #   end
    #   threads.each { |thread| thread.join }
    # end
  end

  it 'works without threads' do
    path = 'spec/support/examples/file/fc84b277-68af-4d63-ac8d-fb8e162ab2a2.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  context 'with IQ datafields' do
    it 'works 1375670253.fit' do
      path = 'spec/support/examples/1375670253.fit'
      data = FitParser.load_file(path)
      expect(data.records).to_not be_nil
    end

    it 'works 1379311720.fit' do
      path = 'spec/support/examples/1379311720.fit'
      data = FitParser.load_file(path)
      expect(data.records).to_not be_nil
    end

    it 'works 6AUI5200.FIT' do
      path = 'spec/support/examples/6AUI5200.fit'
      data = FitParser.load_file(path)
      expect(data.records).to_not be_nil
    end

    it 'works 1426768070-2.fit' do
      path = 'spec/support/examples/1426768070-2.fit'
      data = FitParser.load_file(path)
      expect(data.records).to_not be_nil
    end
  end

  it 'works' do
    %w(
      f334a45f-cd2b-40d8-9c46-b4c34fe9e9dd.
      598363e9-3121-4f24-8b6f-b1368a269e8f.
      7edbeca2-0c62-42b6-9e7a-e869b1e5ccd0.
      dbcdf1a1-3ce0-4e71-a409-bec64c6043b0.
      fcc17445-79ec-43bc-9f7f-ea9324992cd2.
    ).each do |el|
      data = FitParser.load_file("spec/support/examples/file/#{el}")
      expect(data.records).to_not be_nil
    end
  end

  it 'works 7439451200' do
    path = 'spec/support/examples/file/7439451200'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 7420309810' do
    path = 'spec/support/examples/file/7420309810'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 7348726805' do
    path = 'spec/support/examples/file/7348726805'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 16050359900.fit' do
    path = 'spec/support/examples/file/16050359900.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 18119560227.fit' do
    path = 'spec/support/examples/file/18119560227.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 19205208205.fit' do
    path = 'spec/support/examples/file/19205208205.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 23489915119.fit' do
    path = 'spec/support/examples/file/23489915119.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end

  it 'works 24093026216.fit' do
    path = 'spec/support/examples/file/24093026216.fit'
    data = FitParser.load_file(path)
    expect(data.records).to_not be_nil
  end
end
