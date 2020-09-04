require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should return a tree for function call' do
      tokens_list = [
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

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              Return.new(
                Expression.new(:add)))),
          Function.new(
            'add',
            Clause.new(
              Return.new(
                Expression.new(
                  :+,
                  IntegerConstant.new(3),
                  IntegerConstant.new(4)))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call with a parameter' do
      tokens_list = [
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

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              Return.new(
                Expression.new(
                  :double,
                  IntegerConstant.new(4))))),
          Function.new(
            'double',
            Clause.new(
              Parameter.new(:X),
              Return.new(
                Expression.new(
                  :+,
                  Variable.new(:X),
                  Variable.new(:X)))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call with two paramters' do
      tokens_list = [
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

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              Return.new(
                Expression.new(
                  :plus,
                  IntegerConstant.new(3),
                  IntegerConstant.new(8))))),
          Function.new(
            'plus',
            Clause.new(
              Parameter.new(:A),
              Parameter.new(:B),
              Return.new(
                Expression.new(
                  :+,
                  Variable.new(:A),
                  Variable.new(:B)))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end
