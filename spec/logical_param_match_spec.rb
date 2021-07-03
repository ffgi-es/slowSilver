require_relative 'shared'

describe 'logical_param_matching1.sag' do
  include_context 'component test', 'fixtures/logical_param_matching1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'round'),
    Token.new(:integer_constant, 3, 16),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'round'),
    Token.new(:type, 5, :INT),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'round'),
    Token.new(:variable, 7, 'X'),
    Token.new(:condition, 7),
    Token.new(:open_expression, 7),
    Token.new(:variable, 7, 'X'),
    Token.new(:function_call, 7, '%'),
    Token.new(:integer_constant, 7, 10),
    Token.new(:close_expression, 7),
    Token.new(:function_call, 7, '<'),
    Token.new(:integer_constant, 7, 5),
    Token.new(:return, 7),

    Token.new(:variable, 8, 'X'),
    Token.new(:function_call, 8, '-'),
    Token.new(:open_expression, 8),
    Token.new(:variable, 8, 'X'),
    Token.new(:function_call, 8, '%'),
    Token.new(:integer_constant, 8, 10),
    Token.new(:close_expression, 8),
    Token.new(:break, 8),

    Token.new(:identifier, 10, 'round'),
    Token.new(:variable, 10, 'X'),
    Token.new(:return, 10),

    Token.new(:variable, 11, 'X'),
    Token.new(:function_call, 11, '+'),
    Token.new(:open_expression, 11),
    Token.new(:integer_constant, 11, 10),
    Token.new(:function_call, 11, '-'),
    Token.new(:open_expression, 11),
    Token.new(:variable, 11, 'X'),
    Token.new(:function_call, 11, '%'),
    Token.new(:integer_constant, 11, 10),
    Token.new(:close_expression, 11),
    Token.new(:end, 11)
  ]

  include_examples 'no validation error'

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

describe 'logical_param_matching9.sag' do
  include_context 'component test', 'fixtures/logical_param_matching9.sag'

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'blam',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :limit,
              IntegerConstant.new(17))))),
      Function.new(
        'limit',
        { [:INT] => :INT },
        Clause.new(
          Parameter.new(:X),
          Expression.new(
            :>,
            Variable.new(:X),
            IntegerConstant.new(5)),
          Return.new(
            IntegerConstant.new(0))),
        Clause.new(
          Parameter.new(:X),
          nil,
          Return.new(
            Variable.new(:X))))))

  include_examples 'no validation error'

  include_examples 'generation', '_blam', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _blam

    _blam:
        call    init
        mov     rax, 17
        push    rax
        call    _limit
        add     rsp, 8
    #{CodeGen.exit 'rax'}

    _limit:
        push    rbp
        mov     rbp, rsp
    _limit0:
        mov     rax, 5
        push    rax
        mov     rax, [rbp+16]
    #{CodeGen.compare 'setg'}
        cmp     rax, 1
        jne     _limit1
        mov     rax, 0
        jmp     _limitdone
    _limit1:
        mov     rax, [rbp+16]
    _limitdone:
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end
