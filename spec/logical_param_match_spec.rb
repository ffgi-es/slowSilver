require_relative 'shared'

describe 'logical_param_matching1.sag' do
  include_context 'component test', 'fixtures/logical_param_matching1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:function_call, 'round'),
    Token.new(:integer_constant, 16),
    Token.new(:end),

    Token.new(:identifier, 'round'),
    Token.new(:type, :INT),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:function_line),
    Token.new(:identifier, 'round'),
    Token.new(:variable, 'X'),
    Token.new(:condition),
    Token.new(:open_expression),
    Token.new(:variable, 'X'),
    Token.new(:function_call, '%'),
    Token.new(:integer_constant, 10),
    Token.new(:close_expression),
    Token.new(:function_call, '<'),
    Token.new(:integer_constant, 5),
    Token.new(:return),
    Token.new(:variable, 'X'),
    Token.new(:function_call, '-'),
    Token.new(:open_expression),
    Token.new(:variable, 'X'),
    Token.new(:function_call, '%'),
    Token.new(:integer_constant, 10),
    Token.new(:close_expression),
    Token.new(:break),
    Token.new(:identifier, 'round'),
    Token.new(:variable, 'X'),
    Token.new(:return),
    Token.new(:variable, 'X'),
    Token.new(:function_call, '+'),
    Token.new(:open_expression),
    Token.new(:integer_constant, 10),
    Token.new(:function_call, '-'),
    Token.new(:open_expression),
    Token.new(:variable, 'X'),
    Token.new(:function_call, '%'),
    Token.new(:integer_constant, 10),
    Token.new(:close_expression),
    Token.new(:end)
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
              :round,
              IntegerConstant.new(16))))),
      Function.new(
        'round',
        { [:INT] => :INT },
        Clause.new(
          Parameter.new(:X),
          Expression.new(
            :<,
            Expression.new(
              :%,
              Variable.new(:X),
              IntegerConstant.new(10)),
            IntegerConstant.new(5)),
          Return.new(
            Expression.new(
              :-,
              Variable.new(:X),
              Expression.new(
                :%,
                Variable.new(:X),
                IntegerConstant.new(10))))),
        Clause.new(
          Parameter.new(:X),
          nil,
          Return.new(
            Expression.new(
              :+,
              Variable.new(:X),
              Expression.new(
                :-,
                IntegerConstant.new(10),
                Expression.new(
                  :%,
                  Variable.new(:X),
                  IntegerConstant.new(10)))))))))
end

describe 'logical_param_matching2.sag' do
  include_context 'component test', 'fixtures/logical_param_matching2.sag'

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :collatz,
              IntegerConstant.new(3))))),
      Function.new(
        'collatz',
        { [:INT] => :INT },
        Clause.new(
          IntegerConstant.new(1),
          nil,
          Return.new(
            IntegerConstant.new(1))),
        Clause.new(
          Parameter.new(:X),
          Expression.new(
            :"=",
            Expression.new(
              :%,
              Variable.new(:X),
              IntegerConstant.new(2)),
            IntegerConstant.new(0)),
          Return.new(
            Expression.new(
              :/,
              Variable.new(:X),
              IntegerConstant.new(2)))),
        Clause.new(
          Parameter.new(:X),
          nil,
          Return.new(
            Expression.new(
              :+,
              Expression.new(
                :*,
                Variable.new(:X),
                IntegerConstant.new(3)),
              IntegerConstant.new(1)))))))
end
