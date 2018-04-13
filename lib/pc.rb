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
    if( options[:average] ) 
      year = 2017
      monthlyAverage = Array.new
      for month in 1..6
        monthlyOpen = @detective.average_monthly_open(security, year: year, month: month)
        monthlyClose = @detective.average_monthly_close(security, year: year, month: month)
        monthItem = {
          :month => Date.new(year, month, 1).strftime('%Y-%m'),
          :average_open => "$#{monthlyOpen.round(2)}",
          :average_close => "$#{monthlyClose.round(2)}"
        }
        monthlyAverage.push( monthItem )
      end
    end
    result = Hash.new
    result[security] = monthlyAverage 
    log.info result.to_json
  end
end


if __FILE__ == $0
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: pc [options] TICKER"
    opts.on("-t", "--token TOKEN", "Token to access the API") do |givenToken|
      options[:token] = givenToken
    end
    opts.on("-a", "--average", "Prints average opening and closing price for the security") do 
      options[:average] = true
    end
  end.parse!

  raise OptionParser::MissingArgument if options[:token].nil?
  raise OptionParser::MissingArgument if options[:average].nil?
  
  security = ARGV[0]

  pc = PC.new(options[:token])
  pc.run(options, security)
end