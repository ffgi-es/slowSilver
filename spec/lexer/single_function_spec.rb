require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for function1.sag' do
      in_file = File.expand_path '../fixtures/function1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'add'),
        Token.new(:end),
        Token.new(:identifier, 'add'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),
        Token.new(:identifier, 'add'),
        Token.new(:return),
        Token.new(:integer_constant, 3),
        Token.new(:function_call, '+'),
        Token.new(:integer_constant, 4),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for function2.sag' do
      in_file = File.expand_path '../fixtures/function2.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'double'),
        Token.new(:integer_constant, 4),
        Token.new(:end),
        Token.new(:identifier, 'double'),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),
        Token.new(:identifier, 'double'),
        Token.new(:variable, 'X'),
        Token.new(:return),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '+'),
        Token.new(:variable, 'X'),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for function3.sag' do
      in_file = File.expand_path '../fixtures/function3.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 3),
        Token.new(:function_call, 'plus'),
        Token.new(:integer_constant, 8),
        Token.new(:end),
        Token.new(:identifier, 'plus'),
        Token.new(:type, :INT),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),
        Token.new(:identifier, 'plus'),
        Token.new(:variable, 'A'),
        Token.new(:separator),
        Token.new(:variable, 'B'),
        Token.new(:return),
        Token.new(:variable, 'A'),
        Token.new(:function_call, '+'),
        Token.new(:variable, 'B'),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
