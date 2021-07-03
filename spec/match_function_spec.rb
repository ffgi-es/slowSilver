require_relative 'shared'

describe 'params_matching1.sag' do
  include_context 'component test', 'fixtures/params_matching1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'fib'),
    Token.new(:integer_constant, 3, 7),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'fib'),
    Token.new(:type, 5, :INT),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'fib'),
    Token.new(:integer_constant, 7, 0),
    Token.new(:return, 7),
    Token.new(:integer_constant, 7, 0),
    Token.new(:break, 7),

    Token.new(:identifier, 8, 'fib'),
    Token.new(:integer_constant, 8, 1),
    Token.new(:return, 8),
    Token.new(:integer_constant, 8, 1),
    Token.new(:break, 8),

    Token.new(:identifier, 9, 'fib'),
    Token.new(:variable, 9, 'X'),
    Token.new(:return, 9),

    Token.new(:function_call, 10, '+'),

    Token.new(:open_expression, 11),
    Token.new(:function_call, 11, 'fib'),
    Token.new(:open_expression, 11),
    Token.new(:variable, 11, 'X'),
    Token.new(:function_call, 11, '-'),
    Token.new(:integer_constant, 11, 1),
    Token.new(:close_expression, 11),
    Token.new(:close_expression, 11),

    Token.new(:open_expression, 12),
    Token.new(:function_call, 12, 'fib'),
    Token.new(:open_expression, 12),
    Token.new(:variable, 12, 'X'),
    Token.new(:function_call, 12, '-'),
    Token.new(:integer_constant, 12, 2),
    Token.new(:close_expression, 12),
    Token.new(:close_expression, 12),
    Token.new(:end, 12)
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
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, '+'),

    Token.new(:open_expression, 4),
    Token.new(:function_call, 4, 'test'),
    Token.new(:integer_constant, 4, 2),
    Token.new(:integer_constant, 4, 3),
    Token.new(:close_expression, 4),

    Token.new(:open_expression, 5),
    Token.new(:function_call, 5, 'test'),
    Token.new(:integer_constant, 5, 4),
    Token.new(:integer_constant, 5, 5),
    Token.new(:close_expression, 5),
    Token.new(:end, 5),

    Token.new(:identifier, 7, 'test'),
    Token.new(:type, 7, :INT),
    Token.new(:separator, 7),
    Token.new(:type, 7, :INT),
    Token.new(:return, 7),
    Token.new(:type, 7, :INT),

    Token.new(:function_line, 8),

    Token.new(:identifier, 9, 'test'),
    Token.new(:integer_constant, 9, 2),
    Token.new(:separator, 9),
    Token.new(:integer_constant, 9, 3),
    Token.new(:return, 9),
    Token.new(:integer_constant, 9, 1),
    Token.new(:break, 9),

    Token.new(:identifier, 10, 'test'),
    Token.new(:variable, 10, 'X'),
    Token.new(:separator, 10),
    Token.new(:variable, 10, 'Y'),
    Token.new(:return, 10),

    Token.new(:variable, 11, 'X'),
    Token.new(:function_call, 11, '*'),
    Token.new(:variable, 11, 'Y'),
    Token.new(:end, 11)
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
    #{CodeGen.multiply 'rax'}
    _testdone:
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'mixed_param_matching.sag' do
  include_context 'component test', 'fixtures/mixed_param_matching.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'fib'),
    Token.new(:integer_constant, 3, 11),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'fib'),
    Token.new(:type, 5, :INT),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'fib'),
    Token.new(:variable, 7, 'Start'),
    Token.new(:return, 7),
    Token.new(:function_call, 7, 'fib_rec'),
    Token.new(:integer_constant, 7, 0),
    Token.new(:integer_constant, 7, 1),
    Token.new(:variable, 7, 'Start'),
    Token.new(:end, 7),

    Token.new(:identifier, 9, 'fib_rec'),
    Token.new(:type, 9, :INT),
    Token.new(:separator, 9),
    Token.new(:type, 9, :INT),
    Token.new(:separator, 9),
    Token.new(:type, 9, :INT),
    Token.new(:return, 9),
    Token.new(:type, 9, :INT),

    Token.new(:function_line, 10),

    Token.new(:identifier, 11, 'fib_rec'),
    Token.new(:variable, 11, 'X1'),
    Token.new(:separator, 11),
    Token.new(:variable, 11, 'X2'),
    Token.new(:separator, 11),
    Token.new(:integer_constant, 11, 0),
    Token.new(:return, 11),
    Token.new(:variable, 11, 'X1'),
    Token.new(:break, 11),

    Token.new(:identifier, 12, 'fib_rec'),
    Token.new(:variable, 12, 'X1'),
    Token.new(:separator, 12),
    Token.new(:variable, 12, 'X2'),
    Token.new(:separator, 12),
    Token.new(:variable, 12, 'N'),
    Token.new(:return, 12),

    Token.new(:function_call, 13, 'fib_rec'),

    Token.new(:variable, 14, 'X2'),

    Token.new(:open_expression, 15),
    Token.new(:variable, 15, 'X1'),
    Token.new(:function_call, 15, '+'),
    Token.new(:variable, 15, 'X2'),
    Token.new(:close_expression, 15),

    Token.new(:open_expression, 16),
    Token.new(:variable, 16, 'N'),
    Token.new(:function_call, 16, '-'),
    Token.new(:integer_constant, 16, 1),
    Token.new(:close_expression, 16),
    Token.new(:end, 16)
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
