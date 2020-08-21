require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for params_matching1.sag' do
      in_file = File.expand_path '../fixtures/params_matching1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'fib'),
        Token.new(:integer_constant, 7),
        Token.new(:end),
        Token.new(:type, :INT),
        Token.new(:identifier, 'fib'),
        Token.new(:integer_constant, 0),
        Token.new(:return),
        Token.new(:integer_constant, 0),
        Token.new(:break),
        Token.new(:identifier, 'fib'),
        Token.new(:integer_constant, 1),
        Token.new(:return),
        Token.new(:integer_constant, 1),
        Token.new(:break),
        Token.new(:identifier, 'fib'),
        Token.new(:type, :INT),
        Token.new(:variable, 'X'),
        Token.new(:return),
        Token.new(:function_call, '+'),
        Token.new(:open_expression),
        Token.new(:function_call, 'fib'),
        Token.new(:open_expression),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 1),
        Token.new(:close_expression),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:function_call, 'fib'),
        Token.new(:open_expression),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 2),
        Token.new(:close_expression),
        Token.new(:close_expression),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
