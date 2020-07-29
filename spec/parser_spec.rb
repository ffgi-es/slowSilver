require 'parser'
require 'token'
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

    it 'should return a tree for addition' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 6),
        Token.new(:function_call, '+'),
        Token.new(:integer_constant, 3),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :+,
                IntegerConstant.new(6),
                IntegerConstant.new(3))))))

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

    it 'should return a tree for nested expressions' do
      tokens_list = [
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

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :-,
                Expression.new(
                  :+,
                  IntegerConstant.new(13),
                  IntegerConstant.new(2)),
                IntegerConstant.new(5))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for unary function' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, '!'),
        Token.new(:open_expression),
        Token.new(:integer_constant, 13),
        Token.new(:function_call, '='),
        Token.new(:integer_constant, 2),
        Token.new(:close_expression),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :!,
                Expression.new(
                  :"=",
                  IntegerConstant.new(13),
                  IntegerConstant.new(2)))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call' do
      tokens_list = [
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

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(:add))),
          Function.new(
            'add',
            Return.new(
              Expression.new(
                :+,
                IntegerConstant.new(3),
                IntegerConstant.new(4))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call with a parameter' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'double'),
        Token.new(:integer_constant, 4),
        Token.new(:end),
        Token.new(:type, :INT),
        Token.new(:identifier, 'double'),
        Token.new(:type, :INT),
        Token.new(:variable, 'X'),
        Token.new(:return),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '+'),
        Token.new(:variable, 'X'),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :double,
                IntegerConstant.new(4)))),
          Function.new(
            'double',
            Parameter.new(:X),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:X),
                Variable.new(:X))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call with two paramters' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:integer_constant, 3),
        Token.new(:function_call, 'plus'),
        Token.new(:integer_constant, 8),
        Token.new(:end),
        Token.new(:type, :INT),
        Token.new(:identifier, 'plus'),
        Token.new(:type, :INT),
        Token.new(:variable, 'A'),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:variable, 'B'),
        Token.new(:return),
        Token.new(:variable, 'A'),
        Token.new(:function_call, '+'),
        Token.new(:variable, 'B'),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Return.new(
              Expression.new(
                :plus,
                IntegerConstant.new(3),
                IntegerConstant.new(8)))),
          Function.new(
            'plus',
            Parameter.new(:A),
            Parameter.new(:B),
            Return.new(
              Expression.new(
                :+,
                Variable.new(:A),
                Variable.new(:B))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end
