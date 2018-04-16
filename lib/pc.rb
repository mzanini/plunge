require 'restclient/components'
require 'rack/cache'
require 'optionparser'
require_relative 'retriever'
require_relative 'detective'
require_relative 'logging'

class PC 
  include Logging

  def initialize(apiToken)
    @detective = Detective.new( Retriever.new(apiToken) )
  end

  def run(options, security)
    if( options[:caching] )
      RestClient.enable( Rack::Cache, :metastore => 'file:/tmp/cache/meta', :entitystore => 'file:/tmp/cache/body', :verbose => false )
      log.info 'Cache enabled'
    end

    if( options[:verbose] )
      log.level = Logger::INFO
    else
      log.level = Logger::WARN
    end

    if( options[:average] )
      puts compute_average(security).to_json
    end

    if( options[:maximum] )
      maxProfit, day = find_maximum_profit(security)
      puts "Maximum amount of profit: $#{maxProfit.round(2)}, on: #{day.strftime('%d %B %Y')}"
    end
  end

  def compute_average(stock)
    year = 2017
    monthlyAverage = Array.new
    for month in 1..6
      monthlyOpen = @detective.average_monthly_open(stock, year: year, month: month)
      monthlyClose = @detective.average_monthly_close(stock, year: year, month: month)
      monthItem = {
        :month => Date.new(year, month, 1).strftime('%Y-%m'),
        :average_open => "$#{monthlyOpen.round(2)}",
        :average_close => "$#{monthlyClose.round(2)}"
      }
      monthlyAverage.push( monthItem )
    end
    result = Hash.new
    result[stock] = monthlyAverage

    return result
  end

  def find_maximum_profit(stock)
    year = 2017
    maxProfitDay = Date.new(year, 1, 1)
    maxProfit = Float::MIN
    for month in 1..6
      profit, day = @detective.maximum_daily_profit_in_month(stock, year: 2017, month: month)
      if(profit > maxProfit)
        maxProfit = profit
        maxProfitDay = day
      end
    end

    return maxProfit, maxProfitDay
  end

end


if __FILE__ == $0
  options = {}
  options[:caching] = true
  OptionParser.new do |opts|
    opts.banner = "Usage: pc -t <token> [options] TICKER"
    opts.on("-t", "--token TOKEN", "Token to access the API (required)") do |givenToken|
      options[:token] = givenToken
    end
    opts.on("-a", "--average", "Prints average opening and closing price for the security") do 
      options[:average] = true
    end
    opts.on("-m", "--max-daily-profit", "Prints the day with the maximum amount of profit if the security is purchased at the day's low and sold at the day's high.") do 
      options[:maximum] = true
    end
    opts.on("-v", "--verbose", "Sets the log level to INFO") do 
      options[:verbose] = true
    end
    opts.on("-v", "--verbose", "Sets the log level to INFO") do 
      options[:verbose] = true
    end
    opts.on("-nc", "--no-cache", "Disable caching") do 
      options[:caching] = false
    end
  end.parse!

  raise OptionParser::MissingArgument if options[:token].nil?
  
  security = ARGV[0]

  pc = PC.new(options[:token])
  pc.run(options, security)
end