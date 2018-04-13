require_relative 'retriever'
require_relative 'logging'

class Detective
  include Logging

  def initialize(retriever)
    @retriever = retriever
  end

  def average_monthly_open(stock, date)
    days = days_in_month(date[:year], date[:month])
    open_price = Array.new
    for day in 1..days
      dayDate = Date.new(date[:year], date[:month], day)
      openingPrice = @retriever.opening(stock, dayDate)
      open_price.push(openingPrice) if not openingPrice.nil?
    end

    return average(open_price)
  end

  def average_monthly_close(stock, date)
    days = days_in_month(date[:year], date[:month])
    close_price = Array.new
    for day in 1..days
      dayDate = Date.new(date[:year], date[:month], day)
      closingPrice = @retriever.closing(stock, dayDate)
      close_price.push(closingPrice) if not closingPrice.nil?
    end

    return average(close_price)
  end

  def average(prices) 
    log.info "Averaging list of prices: #{prices}"
    sum = 0.00
    for price in prices
      sum += price
    end

    return sum / prices.length
  end

  def days_in_month(year, month)
    Date.new(year, month, -1).day
  end

  private :average, :days_in_month
end
