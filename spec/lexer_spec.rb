require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should return a list of tokens for integer_return1.sag' do
      in_file = File.expand_path 'fixtures/integer_return1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 2),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for integer_return2.sag' do
      in_file = File.expand_path 'fixtures/integer_return2.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 3),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for addition1.sag' do
      in_file = File.expand_path 'fixtures/addition1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
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
      in_file = File.expand_path 'fixtures/addition2.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
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

    it 'should raise an error for an unrecogniseable token "+" for lexer_fail1.sag' do
      in_file = File.expand_path 'fixtures/lexer_fail1.sag', File.dirname(__FILE__)
      lexer = Lexer.new(in_file)
      expect { lexer.lex } .to raise_exception(
        LexError,
        "Unknown token '+'")
    end

    it 'should return a list of tokens for integer_return3.sag' do
      in_file = File.expand_path 'fixtures/integer_return3.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, -2),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for subtraction1.sag' do
      in_file = File.expand_path 'fixtures/subtraction1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 8),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 5),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should raise an error for an unrecogniseable token "<>" lexer_fail2.sag' do
      in_file = File.expand_path 'fixtures/lexer_fail2.sag', File.dirname(__FILE__)
      lexer = Lexer.new(in_file)
      expect { lexer.lex } .to raise_exception(
        LexError,
        "Unknown token '<>'")
    end

    it 'should return a list of tokens for nested_expession1.sag' do
      in_file = File.expand_path 'fixtures/nested_expression1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
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
      in_file = File.expand_path 'fixtures/multiline1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
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

    it 'should return a list of tokens for simple_comparison1.sag' do
      in_file = File.expand_path 'fixtures/simple_comparison1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 3),
        Token.new(:function_call, '='),
        Token.new(:integer_constant, 3),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for not1.sag' do
      in_file = File.expand_path 'fixtures/not1.sag', File.dirname(__FILE__)
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

    it 'should return a list of tokens for function1.sag' do
      in_file = File.expand_path 'fixtures/function1.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'add'),
        Token.new(:end),
        Token.new(:type, :INT),
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
      in_file = File.expand_path 'fixtures/function2.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'double'),
        Token.new(:integer_constant, 4),
        Token.new(:end),
        Token.new(:type, :INT),
        Token.new(:identifier, 'double'),
        Token.new(:type, :INT),
        Token.new(:parameter, 'X'),
        Token.new(:return),
        Token.new(:parameter, 'X'),
        Token.new(:function_call, '+'),
        Token.new(:parameter, 'X'),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end
  end
end
