require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for multiplication1.sag' do
      in_file = File.expand_path '../fixtures/multiplication1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 3),
        Token.new(:function_call, '*'),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
