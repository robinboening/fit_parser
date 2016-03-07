require 'spec_helper'

describe FitParser do
  describe "VERSION" do
    subject{ FitParser::VERSION }

    it { is_expected.to be_a(String) }
    it { is_expected.to match(/\d{1,2}\.\d{1,2}\.\d{1,2}/) }
  end
end
