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
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for sample2.sag' do
      in_file = File.expand_path 'sample2.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should return a list of tokens for sample3.sag' do
      in_file = File.expand_path 'sample3.sag', File.dirname(__FILE__)
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

    it 'should return a list of tokens for sample4.sag' do
      in_file = File.expand_path 'sample4.sag', File.dirname(__FILE__)
      out_tokens = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'concat'),
        Token.new(:integer_constant, 3),
        Token.new(:integer_constant, 2),
        Token.new(:end)
      ]
      lexer = Lexer.new(in_file)
      expect(lexer.lex).to eq out_tokens
    end

    it 'should raise an error for an unrecogniseable token' do
      in_file = File.expand_path 'fail1.sag', File.dirname(__FILE__)
      lexer = Lexer.new(in_file)
      expect { lexer.lex } .to raise_exception(
        LexError,
        "Unknown token '+'")
    end
  end
end
