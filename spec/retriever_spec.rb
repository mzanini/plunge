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
      expect(info['datatable']['data'][0][1]).to eq('2017-06-01')
    end
  end

  describe '#opening' do
    it 'returns the opening price for that stock during that specific day' do
      expect(@retriever.opening('GOOGL', '2017-08-15')).to eq(941.03)
    end
  end

  describe '#closing' do
    it 'returns the closing price for that stock during that specific day' do
      expect(@retriever.closing('GOOGL', '2017-08-15')).to eq(938.08)
    end
  end

end