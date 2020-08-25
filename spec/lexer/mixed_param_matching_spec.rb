require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for mixed_param_matching.sag' do
      in_file = File.expand_path '../fixtures/mixed_param_matching.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'fib'),
        Token.new(:integer_constant, 11),
        Token.new(:end),
        Token.new(:type, :INT),
        Token.new(:identifier, 'fib'),
        Token.new(:type, :INT),
        Token.new(:variable, 'Start'),
        Token.new(:return),
        Token.new(:function_call, 'fib_rec'),
        Token.new(:integer_constant, 0),
        Token.new(:integer_constant, 1),
        Token.new(:variable, 'Start'),
        Token.new(:end),
        Token.new(:type, :INT),
        Token.new(:identifier, 'fib_rec'),
        Token.new(:type, :INT),
        Token.new(:variable, 'X1'),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:variable, 'X2'),
        Token.new(:separator),
        Token.new(:integer_constant, 1),
        Token.new(:return),
        Token.new(:variable, 'X1'),
        Token.new(:break),
        Token.new(:identifier, 'fib_rec'),
        Token.new(:type, :INT),
        Token.new(:variable, 'X1'),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:variable, 'X2'),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:variable, 'N'),
        Token.new(:return),
        Token.new(:function_call, 'fib_rec'),
        Token.new(:variable, 'X2'),
        Token.new(:open_expression),
        Token.new(:variable, 'X1'),
        Token.new(:function_call, '+'),
        Token.new(:variable, 'X2'),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:variable, 'N'),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 1),
        Token.new(:close_expression),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
