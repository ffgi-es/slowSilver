require_relative 'shared'

describe 'function1.sag' do
  include_context 'component test', 'fixtures/function1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'add'),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'add'),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'add'),
    Token.new(:return, 7),
    Token.new(:integer_constant, 7, 3),
    Token.new(:function_call, 7, '+'),
    Token.new(:integer_constant, 7, 4),
    Token.new(:end, 7)
  ]

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(:add)))),
      Function.new(
        'add',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :+,
              IntegerConstant.new(3),
              IntegerConstant.new(4)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        call    _add
    #{CodeGen.exit 'rax'}

    _add:
        mov     rax, 4
        push    rax
        mov     rax, 3
        pop     rcx
        add     rax, rcx
        ret
  ASM
end

describe 'function2.sag' do
  include_context 'component test', 'fixtures/function2.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'double'),
    Token.new(:integer_constant, 3, 4),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'double'),
    Token.new(:type, 5, :INT),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'double'),
    Token.new(:variable, 7, 'X'),
    Token.new(:return, 7),
    Token.new(:variable, 7, 'X'),
    Token.new(:function_call, 7, '+'),
    Token.new(:variable, 7, 'X'),
    Token.new(:end, 7)
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
              :double,
              IntegerConstant.new(4))))),
      Function.new(
        'double',
        { [:INT] => :INT },
        Clause.new(
          Parameter.new(:X),
          nil,
          Return.new(
            Expression.new(
              :+,
              Variable.new(:X),
              Variable.new(:X)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 4
        push    rax
        call    _double
        add     rsp, 8
    #{CodeGen.exit 'rax'}

    _double:
        push    rbp
        mov     rbp, rsp
        mov     rax, [rbp+16]
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        add     rax, rcx
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'function3.sag' do
  include_context 'component test', 'fixtures/function3.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:integer_constant, 3, 3),
    Token.new(:function_call, 3, 'plus'),
    Token.new(:integer_constant, 3, 8),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'plus'),
    Token.new(:type, 5, :INT),
    Token.new(:separator, 5),
    Token.new(:type, 5, :INT),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'plus'),
    Token.new(:variable, 7, 'A'),
    Token.new(:separator, 7),
    Token.new(:variable, 7, 'B'),
    Token.new(:return, 7),
    Token.new(:variable, 7, 'A'),
    Token.new(:function_call, 7, '+'),
    Token.new(:variable, 7, 'B'),
    Token.new(:end, 7)
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
              :plus,
              IntegerConstant.new(3),
              IntegerConstant.new(8))))),
      Function.new(
        'plus',
        { %i[INT INT] => :INT },
        Clause.new(
          Parameter.new(:A),
          Parameter.new(:B),
          nil,
          Return.new(
            Expression.new(
              :+,
              Variable.new(:A),
              Variable.new(:B)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 8
        push    rax
        mov     rax, 3
        push    rax
        call    _plus
        add     rsp, 16
    #{CodeGen.exit 'rax'}

    _plus:
        push    rbp
        mov     rbp, rsp
        mov     rax, [rbp+24]
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        add     rax, rcx
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'function4.sag' do
  include_context 'component test', 'fixtures/function4.sag'

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :sum,
              IntegerConstant.new(3),
              IntegerConstant.new(4),
              IntegerConstant.new(2))))),
      Function.new(
        'sum',
        { %i[INT INT INT] => :INT },
        Clause.new(
          Parameter.new(:A),
          Parameter.new(:B),
          Parameter.new(:C),
          nil,
          Return.new(
            Expression.new(
              :+,
              Expression.new(
                :+,
                Variable.new(:A),
                Variable.new(:B)),
              Variable.new(:C)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 2
        push    rax
        mov     rax, 4
        push    rax
        mov     rax, 3
        push    rax
        call    _sum
        add     rsp, 24
    #{CodeGen.exit 'rax'}

    _sum:
        push    rbp
        mov     rbp, rsp
        mov     rax, [rbp+32]
        push    rax
        mov     rax, [rbp+24]
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        add     rax, rcx
        pop     rcx
        add     rax, rcx
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'nested_functions1.sag' do
  include_context 'component test', 'fixtures/nested_functions1.sag'

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :INT },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :proc,
              IntegerConstant.new(24),
              IntegerConstant.new(7),
              IntegerConstant.new(6))))),
      Function.new(
        'proc',
        { %i[INT INT INT] => :INT },
        Clause.new(
          Parameter.new(:A),
          Parameter.new(:B),
          Parameter.new(:C),
          nil,
          Return.new(
            Expression.new(
              :-,
              Variable.new(:A),
              Expression.new(
                :add,
                Variable.new(:B),
                Variable.new(:C)))))),
      Function.new(
        'add',
        { %i[INT INT] => :INT },
        Clause.new(
          Parameter.new(:A),
          Parameter.new(:B),
          nil,
          Return.new(
            Expression.new(
              :+,
              Variable.new(:A),
              Variable.new(:B)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 6
        push    rax
        mov     rax, 7
        push    rax
        mov     rax, 24
        push    rax
        call    _proc
        add     rsp, 24
    #{CodeGen.exit 'rax'}

    _proc:
        push    rbp
        mov     rbp, rsp
        mov     rax, [rbp+32]
        push    rax
        mov     rax, [rbp+24]
        push    rax
        call    _add
        add     rsp, 16
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        sub     rax, rcx
        mov     rsp, rbp
        pop     rbp
        ret

    _add:
        push    rbp
        mov     rbp, rsp
        mov     rax, [rbp+24]
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        add     rax, rcx
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end
