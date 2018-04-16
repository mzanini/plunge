require 'json'
require_relative '../lib/retriever'

describe Retriever do 

  before :each do
    loggerMock = double('logger').as_null_object
    Logging.set_logger(loggerMock)

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
      stockInfo = @retriever.stock( 'MSFT', Date.parse('2017-06-01') )
      info = JSON.parse(stockInfo)
      expect(info['datatable']['data'][0][0]).to eq('MSFT')
      expect(info['datatable']['data'][0][1]).to eq('2017-06-01')
    end
  end

  describe '#volume' do 
    it 'retrieves the activity volume for that day' do
      volume = @retriever.volume( 'MSFT', Date.parse('2017-06-01') )
      expect(volume).to be_within(0.01).of(21066468.0)
    end
  end

  describe '#opening' do
    it 'returns the opening price for a stock during that specific day' do
      expect( @retriever.opening('GOOGL', Date.parse('2017-08-15')) ).to eq(941.03)
    end

    it 'returns nil if data not present' do
      expect( @retriever.opening('GOOGL', Date.parse('2017-01-01')) ).to eq(nil)
    end
  end

  describe '#closing' do
    it 'returns the closing price for a stock during that specific day' do
      expect( @retriever.closing('GOOGL', Date.parse('2017-08-15')) ).to eq(938.08)
    end

    it 'returns nil if data not present' do
      expect( @retriever.closing('GOOGL', Date.parse('2017-01-01')) ).to eq(nil)
    end
  end

  describe '#opening_and_closing' do
    it 'returns the opening and closing price for a stock during that specific day' do
      openingPrice, closingPrice = @retriever.opening_and_closing('GOOGL', Date.parse('2017-08-15'))
      expect( openingPrice ).to eq(941.03)
      expect( closingPrice ).to eq(938.08)
    end

    it 'returns nil if data not present' do
      openingPrice, closingPrice = @retriever.opening_and_closing('GOOGL', Date.parse('2017-01-01'))
      expect( openingPrice ).to eq(nil)
      expect( closingPrice ).to eq(nil)
    end
  end

  describe '#high_and_low' do
    it 'returns the highest and lowest price for a stock during that specific day' do
      highPrice, lowPrice = @retriever.high_and_low('GOOGL', Date.parse('2017-08-15'))
      expect( lowPrice ).to be <= highPrice
      expect( highPrice ).to eq(943.07)
      expect( lowPrice ).to eq(936.64)
    end

    it 'returns nil if data not present' do
      highPrice, lowPrice = @retriever.high_and_low('GOOGL', Date.parse('2017-01-01'))
      expect( highPrice ).to eq(nil)
      expect( lowPrice ).to eq(nil)
    end
  end

end