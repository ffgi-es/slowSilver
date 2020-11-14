require_relative 'shared'

describe 'local_variables1.sag' do
  include_context 'component test', 'fixtures/local_variables1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:variable, 'A'),
    Token.new(:assign),
    Token.new(:integer_constant, 3),
    Token.new(:separator),
    Token.new(:variable, 'A'),
    Token.new(:function_call, '*'),
    Token.new(:integer_constant, 5),
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
            Declaration.new(
              'A',
              IntegerConstant.new(3)),
            Expression.new(
              :*,
              Variable.new('A'),
              IntegerConstant.new(5)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
    #{CodeGen.function_prologue}
        call    init
        mov     rax, 3
        push    rax
        mov     rax, 5
        push    rax
        mov     rax, [rbp-8]
    #{CodeGen.multiply 'rax'}
    #{CodeGen.function_epilogue}
    #{CodeGen.exit 'rax'}
  ASM
end

describe 'local_variables2.sag' do
  include_context 'component test', 'fixtures/local_variables2.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:variable, 'Str'),
    Token.new(:assign),
    Token.new(:string_constant, 'Hello, Variable!'),
    Token.new(:separator),
    Token.new(:function_call, 'print'),
    Token.new(:variable, 'Str'),
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
            Declaration.new(
              'Str',
              StringConstant.new('Hello, Variable!')),
            Expression.new(
              :print,
              Variable.new('Str')))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
    #{CodeGen.function_prologue}
        call    init
        mov     rax, str0
        push    rax
        mov     rax, [rbp-8]
    #{CodeGen.print 'rax'}
    #{CodeGen.function_epilogue}
    #{CodeGen.exit 'rax'}

    SECTION .data
    str0l   dd 16
    str0    db 'Hello, Variable!'
  ASM
end
