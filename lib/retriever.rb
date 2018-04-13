require 'rest-client'

class Retriever

  attr_accessor :token

  def initialize(token)
    @token = token
  end

  def stock(name, date) 
    response = RestClient.get "https://www.quandl.com/api/v3/datatables/WIKI/PRICES.json?ticker=#{name}&date=#{date}&api_key=#{token}"
    return response.body
  end

end