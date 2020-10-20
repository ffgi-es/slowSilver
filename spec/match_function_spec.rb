require_relative 'shared'

describe 'params_matching1.sag' do
  include_context 'component test', 'fixtures/params_matching1.sag'

  include_examples 'lexing', [
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

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :fib,
              IntegerConstant.new(7))))),
      Function.new(
        'fib',
        { [:INT] => :INT },
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

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 7
        push    rax
        call    _fib
        add     rsp, 8
    #{CodeGen.exit 'rax'}

    _fib:
        push    rbp
        mov     rbp, rsp
    _fib0:
        mov     rax, 0
        cmp     rax, [rbp+16]
        jne     _fib1
        mov     rax, 0
        jmp     _fibdone
    _fib1:
        mov     rax, 1
        cmp     rax, [rbp+16]
        jne     _fib2
        mov     rax, 1
        jmp     _fibdone
    _fib2:
        mov     rax, 2
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        sub     rax, rcx
        push    rax
        call    _fib
        add     rsp, 8
        push    rax
        mov     rax, 1
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        sub     rax, rcx
        push    rax
        call    _fib
        add     rsp, 8
        pop     rcx
        add     rax, rcx
    _fibdone:
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'params_matching2.sag' do
  include_context 'component test', 'fixtures/params_matching2.sag'

  include_examples 'lexing', [
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

    Token.new(:identifier, 'test'),
    Token.new(:variable, 'X'),
    Token.new(:separator),
    Token.new(:variable, 'Y'),
    Token.new(:return),
    Token.new(:variable, 'X'),
    Token.new(:function_call, '*'),
    Token.new(:variable, 'Y'),
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
        { %i[INT INT] => :INT },
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

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 5
        push    rax
        mov     rax, 4
        push    rax
        call    _test
        add     rsp, 16
        push    rax
        mov     rax, 3
        push    rax
        mov     rax, 2
        push    rax
        call    _test
        add     rsp, 16
        pop     rcx
        add     rax, rcx
    #{CodeGen.exit 'rax'}

    _test:
        push    rbp
        mov     rbp, rsp
    _test0:
        mov     rax, 2
        cmp     rax, [rbp+16]
        jne     _test1
        mov     rax, 3
        cmp     rax, [rbp+24]
        jne     _test1
        mov     rax, 1
        jmp     _testdone
    _test1:
        mov     rax, [rbp+24]
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        imul    rax, rcx
    _testdone:
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'mixed_param_matching.sag' do
  include_context 'component test', 'fixtures/mixed_param_matching.sag'

  include_examples 'lexing', [
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

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :fib,
              IntegerConstant.new(11))))),
      Function.new(
        'fib',
        { [:INT] => :INT },
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
        { %i[INT INT INT] => :INT },
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

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 11
        push    rax
        call    _fib
        add     rsp, 8
    #{CodeGen.exit 'rax'}

    _fib:
        push    rbp
        mov     rbp, rsp
        mov     rax, [rbp+16]
        push    rax
        mov     rax, 1
        push    rax
        mov     rax, 0
        push    rax
        call    _fib_rec
        add     rsp, 24
        mov     rsp, rbp
        pop     rbp
        ret

    _fib_rec:
        push    rbp
        mov     rbp, rsp
    _fib_rec0:
        mov     rax, 0
        cmp     rax, [rbp+32]
        jne     _fib_rec1
        mov     rax, [rbp+16]
        jmp     _fib_recdone
    _fib_rec1:
        mov     rax, 1
        push    rax
        mov     rax, [rbp+32]
        pop     rcx
        sub     rax, rcx
        push    rax
        mov     rax, [rbp+24]
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        add     rax, rcx
        push    rax
        mov     rax, [rbp+24]
        push    rax
        call    _fib_rec
        add     rsp, 24
    _fib_recdone:
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end
