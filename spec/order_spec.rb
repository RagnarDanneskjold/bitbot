require_relative 'spec_helper'

describe BitBot::Order do
  describe "#executed" do
    subject { described_class.new(amount: '1.0') }

    it 'calculates executed amount' do
      subject.remaining = '0.1235'
      expect(subject.executed).to eq(0.8765)
    end

    it 'handles empty @remaining' do
      expect(subject.executed).to eq(0.0)
    end
  end
end
