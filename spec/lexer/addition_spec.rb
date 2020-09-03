require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for addition1.sag' do
      in_file = File.expand_path '../fixtures/addition1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 2),
        Token.new(:function_call, '+'),
        Token.new(:integer_constant, 2),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for addition2.sag' do
      in_file = File.expand_path '../fixtures/addition2.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, '+'),
        Token.new(:integer_constant, 2),
        Token.new(:integer_constant, 3),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
