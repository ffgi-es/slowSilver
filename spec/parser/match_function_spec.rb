require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should return a tree for function call with parameter matching' do
      tokens_list = [
        Token.new(:type, :INT),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'fib'),
        Token.new(:integer_constant, 7),
        Token.new(:end),
        Token.new(:type, :INT),
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
        Token.new(:type, :INT),
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
            Return.new(
              Expression.new(
                :fib,
                IntegerConstant.new(7)))),
          MatchFunction.new(
            'fib',
            Clause.new(
              IntegerConstant.new(0),
              Return.new(
                IntegerConstant.new(0))),
            Clause.new(
              IntegerConstant.new(1),
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
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
        Token.new(:type, :INT),
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
        Token.new(:type, :INT),
        Token.new(:identifier, 'test'),
        Token.new(:integer_constant, 2),
        Token.new(:separator),
        Token.new(:integer_constant, 3),
        Token.new(:return),
        Token.new(:integer_constant, 1),
        Token.new(:break),
        Token.new(:identifier, 'fib'),
        Token.new(:type, :INT),
        Token.new(:variable, 'X'),
        Token.new(:separator),
        Token.new(:type, :INT),
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
                  IntegerConstant.new(5))))),
          MatchFunction.new(
            'test',
            Clause.new(
              IntegerConstant.new(2),
              IntegerConstant.new(3),
              Return.new(
                IntegerConstant.new(1))),
            Clause.new(
              Parameter.new(:X),
              Parameter.new(:Y),
              Return.new(
                Expression.new(
                  :*,
                  Variable.new(:X),
                  Variable.new(:Y)))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end
