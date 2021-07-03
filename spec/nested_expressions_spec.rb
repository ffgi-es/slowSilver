require_relative 'shared'

describe 'nested_expression1.sag' do
  include_context 'component test', 'fixtures/nested_expression1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:open_expression, 3),
    Token.new(:integer_constant, 3, 13),
    Token.new(:function_call, 3, '+'),
    Token.new(:integer_constant, 3, 2),
    Token.new(:close_expression, 3),
    Token.new(:function_call, 3, '-'),
    Token.new(:integer_constant, 3, 5),
    Token.new(:end, 3)
  ]

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
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
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, '+'),

    Token.new(:open_expression, 4),
    Token.new(:integer_constant, 4, 12),
    Token.new(:function_call, 4, '-'),
    Token.new(:integer_constant, 4, 3),
    Token.new(:close_expression, 4),

    Token.new(:open_expression, 5),
    Token.new(:integer_constant, 5, 32),
    Token.new(:function_call, 5, '-'),
    Token.new(:integer_constant, 5, 14),
    Token.new(:close_expression, 5),
    Token.new(:end, 5)
  ]
end
