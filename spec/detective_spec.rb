require_relative '../lib/detective'

describe 'detective' do
  before :all do 
    token = File.open('token', 'r').read
    @retriever = Retriever.new(token);
    @detective = Detective.new( @retriever )
  end

  describe '#average_monthly_open' do
    it 'returns the average opening price for a stock during a specific year and month' do
      expect( @detective.average_monthly_open('GOOGL', year: 2017, month: 01) ).to be_within(0.01).of(829.85)
    end
  end

  describe '#average_monthly_close' do
    it 'returns the average closing price for a stock during a specific year and month' do
      expect( @detective.average_monthly_close('GOOGL', year: 2017, month: 01) ).to be_within(0.01).of(830.24)
    end
  end
end