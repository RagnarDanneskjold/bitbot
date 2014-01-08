module BitBot
  class Error < StandardError; end
  class UnknowError < Error; end
  class BalanceError < Error; end
  class InsufficientMoneyError < BalanceError; end
  class InsufficientCoinError < BalanceError; end
  class OrderNotFoundError < Error; end
  class InvalidParamsError < Error; end
  class InvalidPriceError < InvalidParamsError; end
  class UnauthorizedError < Error; end
end
