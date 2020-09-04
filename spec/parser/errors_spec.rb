require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should throw an error for missing return value' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:end)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Unexpected token: '.'")
    end

    it 'should throw an error for a missing full stop' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Expected token: '.'")
    end

    it 'should throw an error for a missing =>' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Unexpected token: '.'")
    end
  end
end
