require_relative 'spec_helper'

describe BitBot::Ticker do
  describe "#initialize" do
    subject { described_class.new last: '100', ask: '100.1' }

    it "convert Float field's values to float" do
      expect(subject.last).to equal(100.0)
      expect(subject.ask).to eq(100.1)
    end
  end
end
