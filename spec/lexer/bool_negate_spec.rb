require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for not1.sag' do
      in_file = File.expand_path '../fixtures/not1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, '!'),
        Token.new(:open_expression),
        Token.new(:integer_constant, 4),
        Token.new(:function_call, '='),
        Token.new(:integer_constant, 8),
        Token.new(:close_expression),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end