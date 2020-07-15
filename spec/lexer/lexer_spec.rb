require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for sample1.sag' do
      in_file = File.expand_path 'sample1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 4),
        Token.new(:end)
      ]
      expect(Lexer.lex in_file).to eq out_tokens
    end

    it "should return a list of tokens for sample2.sag" do
      in_file = File.expand_path "sample2.sag", File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6),
        Token.new(:end),
      ]
      expect(Lexer.lex in_file).to eq out_tokens
    end
  end
end
