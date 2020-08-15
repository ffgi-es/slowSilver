require 'lexer'
require 'token'

describe 'Lexer' do
  describe '#lex' do
    it 'should raise an error for an unrecogniseable token "+" for lexer_fail1.sag' do
      in_file = File.expand_path '../fixtures/lexer_fail1.sag', File.dirname(__FILE__)
      lexer = Lexer.new(in_file)
      expect { lexer.lex } .to raise_exception(
        LexError,
        "Unknown token '+'")
    end

    it 'should raise an error for an unrecogniseable token "<>" lexer_fail2.sag' do
      in_file = File.expand_path '../fixtures/lexer_fail2.sag', File.dirname(__FILE__)
      lexer = Lexer.new(in_file)
      expect { lexer.lex } .to raise_exception(
        LexError,
        "Unknown token '<>'")
    end
  end
end
