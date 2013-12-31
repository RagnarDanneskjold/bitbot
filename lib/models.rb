module BitBot
  class Base
    def initialize(attrs)
      attrs.each do |key, value|
        self.send("#{key}=", value)
      end
    end

  end

  class Ticker < Base
    attr_accessor :last, :ask, :bid, :high, :low, :vol, :timestamp
  end

  class Order < Base
    #### BitFinex ###
    # "symbol"=>"btcusd", "exchange"=>nil, "avg_execution_price"=>"0.0", "side"=>"buy",
    # "type"=>"exchange limit", "is_live"=>true, "is_cancelled"=>false, "was_forced"=>false,
    # "original_amount"=>"0.1", "remaining_amount"=>"0.1", "executed_amount"=>"0.0"
    #
    #### BTCChina ###
    # "type"=>"ask", "currency"=>"CNY", "amount"=>"0.10000000", "amount_original"=>"0.10000000", "date"=>1388473594, "status"=>"open"
    attr_accessor :id, :type, :price, :avg_price, :amount, :remaining, :status, :currency, :timestamp
  end

  class Offer < Base
    attr_accessor :price, :amount, :timestamp
  end
end
