require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should return a tree for logical param conditions' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, 'blam'),
        Token.new(:integer_constant, 3),
        Token.new(:end),
        Token.new(:identifier, 'blam'),
        Token.new(:type, :INT),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'blam'),
        Token.new(:variable, 'X'),
        Token.new(:condition),
        Token.new(:variable, 'X'),
        Token.new(:function_call, '<'),
        Token.new(:integer_constant, 5),
        Token.new(:return),
        Token.new(:integer_constant, 0),
        Token.new(:break),
        Token.new(:identifier, 'blam'),
        Token.new(:variable, 'X'),
        Token.new(:return),
        Token.new(:variable, 'X'),
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
                  :blam,
                  IntegerConstant.new(3))))),
          Function.new(
            'blam',
            Clause.new(
              Parameter.new('X'),
              Expression.new(
                :<,
                Variable.new('X'),
                IntegerConstant.new(5)),
              Return.new(
                IntegerConstant.new(0))),
            Clause.new(
              Parameter.new('X'),
              nil,
              Return.new(
                Variable.new('X'))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end
