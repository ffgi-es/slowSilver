require_relative 'shared'

describe 'nested_expression1.sag' do
  include_context 'component test', 'fixtures/nested_expression1.sag'

  include_examples 'lexing', [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
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

  include_examples 'parsing', ASTree.new(
        Program.new(
          Function.new(
            'main',
            {[] => :INT},
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :-,
                  Expression.new(
                    :+,
                    IntegerConstant.new(13),
                    IntegerConstant.new(2)),
                  IntegerConstant.new(5)))))))

  include_examples 'no validation error'
end

describe 'multiline1.sag' do
  include_context 'component test', 'fixtures/multiline1.sag'

  include_examples 'lexing', [
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:type, :INT),
        Token.new(:entry_function_line),
        Token.new(:identifier, 'main'),
        Token.new(:return),
        Token.new(:function_call, '+'),
        Token.new(:open_expression),
        Token.new(:integer_constant, 12),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 3),
        Token.new(:close_expression),
        Token.new(:open_expression),
        Token.new(:integer_constant, 32),
        Token.new(:function_call, '-'),
        Token.new(:integer_constant, 14),
        Token.new(:close_expression),
        Token.new(:end)
  ]
end
