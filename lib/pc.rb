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

    if( options[:busyDay] )
      averageActivity = @detective.average_activity_level(security, year: 2017, firstMonth: 1, lastMonth: 6)
      puts "The average activity for #{security} was #{averageActivity}"
      busyDays = find_busy_days(security, averageActivity)
      busyDays.each do |dayInfo|
        puts "#{dayInfo[:day].strftime('%B %d, %Y')} was a busy day! Volume: #{dayInfo[:volume]}"
      end
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

  def find_busy_days(stock, averageActivity)
    year = 2017
    busyDays = Array.new
    for month in 1..6
      days = days_in_month(year, month)
      for day in 1..days
        dailyVolume = @detective.retriever.volume( stock, Date.new(year, month, day) )
        if(not dailyVolume.nil?)
          if( is_10_percent_higher(averageActivity, dailyVolume) )
            busyDays << {:day => Date.new(year, month, day), :volume => dailyVolume}
          end
        end
      end
    end

    return busyDays
  end

  def is_10_percent_higher(average, current)
    return current / average > 1.10
  end

  def days_in_month(year, month)
    Date.new(year, month, -1).day
  end

  private :days_in_month
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
    opts.on("-bd", "--busy-day", "Display the days where the volume was more than 10% higher than the security’s average volume.") do 
      options[:busyDay] = true
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