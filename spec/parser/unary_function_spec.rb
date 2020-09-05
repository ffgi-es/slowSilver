require 'parser'
require 'token'
require 'pprint'

describe 'Parser' do
  describe '#parse' do
    it 'should return a tree for unary function' do
      tokens_list = [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
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
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :!,
                  Expression.new(
                    :"=",
                    IntegerConstant.new(13),
                    IntegerConstant.new(2))))))))

      actual_ast = Parser.parse(tokens_list)

      expect(PPrinter.format(actual_ast))
        .to eq PPrinter.format(expected_ast)
    end
  end
end
