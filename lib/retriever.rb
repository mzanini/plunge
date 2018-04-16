require 'rest-client'
require 'json'
require 'date'
require_relative 'logging'

class Retriever

  include Logging

  attr_accessor :token

  def initialize(token)
    @token = token
    @base_url = 'https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?'
  end

  def stock(name, date) 
    log.info "Retrieving stock info for stock: #{name} at date: #{date}"
    response = query_api(name, date)
    
    return response
  end

  def volume(name, date) 
    log.info "Retrieving volume info for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'volume')

    return data(response, 0)
  end

  def opening(name, date)
    log.info "Retrieving stock opening price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'open')
    
    return data(response, 0)
  end

  def closing(name, date)
    log.info "Retrieving stock closing price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'close')
    
    return data(response, 0)
  end

  def opening_and_closing(name, date) 
    log.info "Retrieving opening and closing price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'open,close')
    
    return data(response, 0), data(response, 1)
  end

  def high_and_low(name, date) 
    log.info "Retrieving opening and closing price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'high,low')
    
    return data(response, 0), data(response, 1)
  end

  def query_api(stock, date, columns = nil)
    if not columns.nil?
      colums_selector = "qopts.columns=#{columns}"    
    else
      colums_selector = ''
    end 

    begin
      response = RestClient.get "#{@base_url}ticker=#{stock}&api_key=#{token}&date=#{date.strftime('%Y-%m-%d')}&#{colums_selector}"
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    
    return response.body
  end

  def data(responseJson, position)
    data = JSON.parse(responseJson)
    begin
      return data['datatable']['data'][0][position]
    rescue
      return nil
    end
  end

  private :query_api, :data
end