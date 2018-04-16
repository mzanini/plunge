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

    data = JSON.parse(response)
    begin
      return data['datatable']['data'][0][0]
    rescue
      return nil
    end
  end

  def opening(name, date)
    log.info "Retrieving stock opening price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'open')
    
    data = JSON.parse(response)
    begin
      return data['datatable']['data'][0][0]
    rescue
      return nil
    end
  end

  def closing(name, date)
    log.info "Retrieving stock closing price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'close')
    
    data = JSON.parse(response)
    begin
      return data['datatable']['data'][0][0]
    rescue
      return nil
    end
  end

  def opening_and_closing(name, date) 
    log.info "Retrieving opening and closing price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'open,close')
    
    data = JSON.parse(response)
    begin
      return data['datatable']['data'][0][0], data['datatable']['data'][0][1]
    rescue
      return nil
    end
  end

  def high_and_low(name, date) 
    log.info "Retrieving opening and closing price for stock: #{name} at date: #{date}"
    response = query_api(name, date, 'high,low')
    
    data = JSON.parse(response)
    begin
      return data['datatable']['data'][0][0], data['datatable']['data'][0][1]
    rescue
      return nil
    end
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

  private :query_api
end