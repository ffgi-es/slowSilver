require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should throw an error for missing return value' do
      tokens_list = [
        Token.new(:identifier, 0, 'main'),
        Token.new(:return, 0),
        Token.new(:type, 0, :INT),
        Token.new(:entry_function_line, 0),
        Token.new(:identifier, 0, 'main'),
        Token.new(:return, 0),
        Token.new(:end, 0)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Unexpected token: '.'")
    end

    it 'should throw an error for a missing full stop' do
      tokens_list = [
        Token.new(:identifier, 0, 'main'),
        Token.new(:return, 0),
        Token.new(:type, 0, :INT),
        Token.new(:entry_function_line, 0),
        Token.new(:identifier, 0, 'main'),
        Token.new(:return, 0),
        Token.new(:integer_constant, 0, 6)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Expected token: '.'")
    end

    it 'should throw an error for a missing =>' do
      tokens_list = [
        Token.new(:identifier, 0, 'main'),
        Token.new(:return, 0),
        Token.new(:type, 0, :INT),
        Token.new(:entry_function_line, 0),
        Token.new(:identifier, 0, 'main'),
        Token.new(:integer_constant, 0, 6),
        Token.new(:end, 0)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Unexpected token: 'end' on line 0")
    end
  end
end
