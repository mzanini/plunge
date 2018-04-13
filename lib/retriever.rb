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
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=#{name}&date=#{date.strftime('%Y-%m-%d')}&api_key=#{token}"
    return response.body
  end

  def opening(name, date)
    log.info "Retrieving stock opening price for stock: #{name} at date: #{date}"
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?qopts.columns=open&ticker=#{name}&date=#{date.strftime('%Y-%m-%d')}&api_key=#{token}"
    data = JSON.parse(response.body)
    return data['datatable']['data'][0][0]
  end

  def closing(name, date)
    log.info "Retrieving stock closing price for stock: #{name} at date: #{date}"
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?qopts.columns=close&ticker=#{name}&date=#{date.strftime('%Y-%m-%d')}&api_key=#{token}"
    data = JSON.parse(response.body)
    return data['datatable']['data'][0][0]
  end

end