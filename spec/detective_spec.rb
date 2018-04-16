require_relative '../lib/detective'

describe 'detective' do
  before :each do 
    loggerMock = double('logger').as_null_object
    Logging.set_logger(loggerMock)

    token = File.open('token', 'r').read
    @retriever = Retriever.new(token)
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

  describe '#maximum_daily_profit_in_month' do
    it 'returns the profit obtained if the security is purchased at the day\'s low and sold at the day\'s high, at the day at which this happened' do
      profit, day = @detective.maximum_daily_profit_in_month('GOOGL', year: 2017, month: 01)
      expect( profit ).to be_within(0.01).of(25.10)
      expect( day ).to eq( Date.parse('2017-01-27') )
    end

    it 'returns the profit obtained if the security is purchased at the day\'s low and sold at the day\'s high, at the day at which this happened. Other example.' do
      profit, day = @detective.maximum_daily_profit_in_month('MSFT', year: 2017, month: 04)
      expect( profit ).to be_within(0.01).of(1.45)
      expect( day ).to eq( Date.parse('2017-04-28') )
    end
  end

end