require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for nested_expession1.sag' do
      in_file = File.expand_path '../fixtures/nested_expression1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:open_expression),
        Token.new(:integer_constant, 13),
        Token.new(:function_call, '+'),
        Token.new(:integer_constant, 2),
        Token.new(:close_expression),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 5),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for multiline1.sag' do
      in_file = File.expand_path '../fixtures/multiline1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, '+'),
        Token.new(:open_expression),
        Token.new(:integer_constant, 12),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 3),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:integer_constant, 32),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 14),
        Token.new(:close_expression),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
