module BitBot
  class Base
    attr_reader :currency
    def initialize(attrs)
      @currency = 'USD' if ["bitfinex"].include?(name.to_s)
      @currency = 'RMB' if ["btcchina"].include?(name.to_s)

      attrs.each do |key, value|
        next if key.nil?
        value = value.to_f if [:last, :ask, :bid, :high, :low, :original_price, :avg_price, :amount, :remaining].include?(key.to_sym)
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
      end

      if respond_to?(:timestamp)
        if @timestamp
          @timestamp = @timestamp.to_i
        else
          @timestamp = Time.now.to_i
        end
      end
    end

    def name
      self.class.name
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
    attr_accessor :id, :type, :original_price, :avg_price, :amount, :remaining, :status, :currency, :timestamp, :order_type

    def price
      ( (original_price || avg_price).to_f * ( currency == 'RMB' ? 1 : Settings.rate ) ).round(2)
    end

    def executed
      @amount.to_f - @remaining.to_f
    end
  end

  class Offer < Base
    attr_accessor :original_price, :amount, :timestamp, :currency

    def price
      (original_price * ( currency == 'RMB' ? 1 : Settings.rate )).round(2)
    end
  end
end
