require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should return a tree for function call with parameter matching' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'fib'),
        Token.new(:integer_constant, 7),
        Token.new(:end),

        Token.new(:identifier, 'fib'),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),

        Token.new(:identifier, 'fib'),
        Token.new(:integer_constant, 0),
        Token.new(:return),
        Token.new(:integer_constant, 0),
        Token.new(:break),

        Token.new(:identifier, 'fib'),
        Token.new(:integer_constant, 1),
        Token.new(:return),
        Token.new(:integer_constant, 1),
        Token.new(:break),

        Token.new(:identifier, 'fib'),
        Token.new(:variable, 'X'),
        Token.new(:return),
        Token.new(:function_call, '+'),
        Token.new(:open_expression),
        Token.new(:function_call, 'fib'),
        Token.new(:open_expression),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 1),
        Token.new(:close_expression),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:function_call, 'fib'),
        Token.new(:open_expression),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 2),
        Token.new(:close_expression),
        Token.new(:close_expression),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :fib,
                  IntegerConstant.new(7))))),
          Function.new(
            'fib',
            Clause.new(
              IntegerConstant.new(0),
              nil,
              Return.new(
                IntegerConstant.new(0))),
            Clause.new(
              IntegerConstant.new(1),
              nil,
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
              nil,
              Return.new(
                Expression.new(
                  :+,
                  Expression.new(
                    :fib,
                    Expression.new(
                      :-,
                      Variable.new(:X),
                      IntegerConstant.new(1))),
                  Expression.new(
                    :fib,
                    Expression.new(
                      :-,
                      Variable.new(:X),
                      IntegerConstant.new(2)))))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call with parameter matching for multiple parameters' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, '+'),
        Token.new(:open_expression),
        Token.new(:function_call, 'test'),
        Token.new(:integer_constant, 2),
        Token.new(:integer_constant, 3),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:function_call, 'test'),
        Token.new(:integer_constant, 4),
        Token.new(:integer_constant, 5),
        Token.new(:close_expression),
        Token.new(:end),

        Token.new(:identifier, 'test'),
        Token.new(:type, :INT),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),

        Token.new(:identifier, 'test'),
        Token.new(:integer_constant, 2),
        Token.new(:separator),
        Token.new(:integer_constant, 3),
        Token.new(:return),
        Token.new(:integer_constant, 1),
        Token.new(:break),

        Token.new(:identifier, 'fib'),
        Token.new(:variable, 'X'),
        Token.new(:separator),
        Token.new(:variable, 'Y'),
        Token.new(:return),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '*'),
        Token.new(:variable, 'Y'),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :+,
                  Expression.new(
                    :test,
                    IntegerConstant.new(2),
                    IntegerConstant.new(3)),
                  Expression.new(
                    :test,
                    IntegerConstant.new(4),
                    IntegerConstant.new(5)))))),
          Function.new(
            'test',
            Clause.new(
              IntegerConstant.new(2),
              IntegerConstant.new(3),
              nil,
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
              Parameter.new(:Y),
              nil,
              Return.new(
                Expression.new(
                  :*,
                  Variable.new(:X),
                  Variable.new(:Y)))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end

    it 'should return a tree for function call with parameter matching for mixed parameters' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'fib'),
        Token.new(:integer_constant, 11),
        Token.new(:end),

        Token.new(:identifier, 'fib'),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),

        Token.new(:identifier, 'fib'),
        Token.new(:variable, 'Start'),
        Token.new(:return),
        Token.new(:function_call, 'fib_rec'),
        Token.new(:integer_constant, 0),
        Token.new(:integer_constant, 1),
        Token.new(:variable, 'Start'),
        Token.new(:end),

        Token.new(:identifier, 'fib_rec'),
        Token.new(:type, :INT),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:separator),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:function_line),

        Token.new(:identifier, 'fib_rec'),
        Token.new(:variable, 'X1'),
        Token.new(:separator),
        Token.new(:variable, 'X2'),
        Token.new(:separator),
        Token.new(:integer_constant, 0),
        Token.new(:return),
        Token.new(:variable, 'X1'),
        Token.new(:break),

        Token.new(:identifier, 'fib_rec'),
        Token.new(:variable, 'X1'),
        Token.new(:separator),
        Token.new(:variable, 'X2'),
        Token.new(:separator),
        Token.new(:variable, 'N'),
        Token.new(:return),
        Token.new(:function_call, 'fib_rec'),
        Token.new(:variable, 'X2'),
        Token.new(:open_expression),
        Token.new(:variable, 'X1'),
        Token.new(:function_call, '+'),
        Token.new(:variable, 'X2'),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:variable, 'N'),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 1),
        Token.new(:close_expression),
        Token.new(:end)
      ]

      expected_ast = ASTree.new(
        Program.new(
          Function.new(
            'main',
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :fib,
                  IntegerConstant.new(11))))),
          Function.new(
            'fib',
            Clause.new(
              Parameter.new(:Start),
              nil,
              Return.new(
                Expression.new(
                  :fib_rec,
                  IntegerConstant.new(0),
                  IntegerConstant.new(1),
                  Variable.new(:Start))))),
          Function.new(
            'fib_rec',
            Clause.new(
              Parameter.new(:X1),
              Parameter.new(:X2),
              IntegerConstant.new(0),
              nil,
              Return.new(
                Variable.new(:X1))),
            Clause.new(
              Parameter.new(:X1),
              Parameter.new(:X2),
              Parameter.new(:N),
              nil,
              Return.new(
                Expression.new(
                  :fib_rec,
                  Variable.new(:X2),
                  Expression.new(
                    :+,
                    Variable.new(:X1),
                    Variable.new(:X2)),
                  Expression.new(
                    :-,
                    Variable.new(:N),
                    IntegerConstant.new(1))))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end
