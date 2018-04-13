require 'rest-client'
require 'json'

class Retriever

  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def stock(name, date) 
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=#{name}&date=#{date}&api_key=#{token}"
    return response.body
  end

  def opening(name, date)
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?qopts.columns=open&ticker=#{name}&date=#{date}&api_key=#{token}"
    data = JSON.parse(response.body)
    return data['datatable']['data'][0][0]
  end

  def closing(name, date)
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?qopts.columns=close&ticker=#{name}&date=#{date}&api_key=#{token}"
    data = JSON.parse(response.body)
    return data['datatable']['data'][0][0]
  end

end