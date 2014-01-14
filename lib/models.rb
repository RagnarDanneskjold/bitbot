module BitBot
  class Converter
    attr_reader :model
    def initialize(model)
      @model = model
    end

    def method_missing(mth, *args, &blk)
      value = @model.send(mth, *args, &blk)
      (value * @model.rate).round(5)
    rescue NoMethodError
      super
    end
  end

  class Base
    include Mongoid::Document
    field :original, type: Hash
    field :timestamp, type: Time, default: -> { Time.now }
    field :agent

    def currency
      agent ? agent.currency : 'USD'
    end

    def rate
      agent ? agent.rate : 0
    end

    def converted
      @converter ||= Converter.new(self)
    end

    def as_json
      attributes.merge('_type' => self.class.name).as_json
    end
  end

  class Ticker < Base
    field :last, type: Float, default: 0
    field :ask, type: Float, default: 0
    field :bid, type: Float, default: 0
    field :high, type: Float, default: 0
    field :low, type: Float, default: 0
    field :vol, type: Float, default: 0
  end

  class Order < Base
    field :order_id, type: Integer
    field :side, type: String # 'buy', 'sell'
    field :type, type: String # 'exchange market', 'exchange limit'
    field :price, type: Float, default: 0
    field :avg_price, type: Float, default: 0
    field :amount, type: Float, default: 0
    field :remaining, type: Float
    field :status, type: String, default: 'open'

    def executed
      (amount - remaining).round(5)
    end

    after_initialize do
      self.remaining = amount if remaining.nil?
    end
  end

  class Offer < Base
    field :price, type: Float
    field :amount, type: Float
  end

  class Account < Base
    embeds_many :balances

    def btc_balance
      balances.detect{|bln| bln.currency == 'BTC'}
    end
    def fiat_balance
      balances.detect{|bln| bln.currency == currency}
    end

    def as_json
      super.merge('balances' => balances.as_json)
    end
  end

  class Balance < Base
    embedded_in :account
    field :currency, type: String
    field :amount, type: Float
  end
end
