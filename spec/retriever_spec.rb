require 'json'
require_relative '../lib/retriever'

describe Retriever do 

  before :all do
    token = File.open('token', 'r').read
    @retriever = Retriever.new(token);
  end

  describe '#initialize' do
    it 'is initialized with the token' do
      token = File.open('token', 'r').read 
      expect(@retriever.token).to eq(token)  
    end
  end

  describe '#stock' do 
    it 'retrieves all data for the specified security for that day' do
      stockInfo = @retriever.stock('MSFT', '2017-06-01')
      info = JSON.parse(stockInfo)
      expect(info['datatable']['data'][0][0]).to eq('MSFT')
    end
  end

end