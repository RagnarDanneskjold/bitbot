require_relative 'spec_helper'

describe BitBot::Base do
  describe "#initialize" do
    subject { described_class.new(any: 'thing'){|b| b.original = {a: 1}} }

    it 'accepts hash and block to initialize instance' do
      expect(subject.any).to eq('thing')
      expect(subject.original).to eq(a: 1)
      expect(subject.currency).to eq('USD')
    end
  end

  describe "#currency" do
    BitBot.define :cny_agent, Module.new do
      def currency; 'CNY' end
      def rate; 1 end
    end
    subject { described_class.new }

    it "uses agent's currency as its currency" do
      subject.agent = BitBot[:cny_agent].new
      expect(subject.currency).to eq('CNY')
    end
  end

  describe "#converted" do
    BitBot.define :usd_agent, Module.new do
      def currency; 'USD' end
      def rate; 6.06 end
    end
    subject { Class.new(described_class){ field :price, type: Float }.new(price: 1) }

    it "converts price to CNY currency automatically" do
      subject.agent = BitBot[:usd_agent].new
      expect(subject.price).to eq(1.0)
      expect(subject.converted.price).to eq(6.06)
      expect{subject.converted.unknown}.to raise_error(NoMethodError)
    end
  end
end
