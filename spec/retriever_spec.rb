require_relative '../lib/retriever'

describe Retriever do 
  describe '#initialize' do
    it 'is initialized with the token' do 
      token = File.open('token', 'r').read
      retriever = Retriever.new(token);
      expect(retriever.token).to eq(token)  
    end
  end

end