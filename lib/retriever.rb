require 'rest-client'
require 'json'
require 'date'
require_relative 'logging'

class Retriever

  include Logging

  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def stock(name, date) 
    log.info "Retrieving stock info for stock: #{name} at date: #{date}"
    begin
      response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=#{name}&date=#{date.strftime('%Y-%m-%d')}&api_key=#{token}"
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    
    return response.body
  end

  def opening(name, date)
    log.info "Retrieving stock opening price for stock: #{name} at date: #{date}"
    begin
      response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?qopts.columns=open&ticker=#{name}&date=#{date.strftime('%Y-%m-%d')}&api_key=#{token}"
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    
    data = JSON.parse(response.body)
    begin
      return data['datatable']['data'][0][0]
    rescue
      return nil
    end
  end

  def closing(name, date)
    log.info "Retrieving stock closing price for stock: #{name} at date: #{date}"
    begin
      response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?qopts.columns=close&ticker=#{name}&date=#{date.strftime('%Y-%m-%d')}&api_key=#{token}"
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    
    data = JSON.parse(response.body)
    begin
      return data['datatable']['data'][0][0]
    rescue
      return nil
    end
  end

end