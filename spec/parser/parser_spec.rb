require 'parser'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should return AST for returning 4' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 4),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              IntegerConstant.new(4)))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return AST for returning 3' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              IntegerConstant.new(6)))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should throw an error for missing return value' do
      tokens_list = [
        Token.new(:type, :INT),
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
        Token.new(:type, :INT),
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
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Unexpected token: '6'")
    end

    it 'should throw an error for a missing funtion type' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6),
        Token.new(:end)
      ]

      expect { Parser.parse tokens_list } .to raise_exception(
        ParseError,
        "Unexpected token: 'main'")
    end
  end
end
