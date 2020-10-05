require_relative 'shared'

describe 'greater_than1.sag' do
  include_context 'component test', 'fixtures/greater_than1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:integer_constant, 4),
    Token.new(:function_call, '>'),
    Token.new(:integer_constant, 3),
    Token.new(:end)
  ]

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 3
        push    rax
        mov     rax, 4
        pop     rcx
    #{CodeGen.compare 'rcx', 'setg'}
    #{CodeGen.exit 'rax'}
  ASM
end

describe 'greater_than_equal1.sag' do
  include_context 'component test', 'fixtures/greater_than_equal1.sag'

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 3
        push    rax
        mov     rax, 4
        pop     rcx
    #{CodeGen.compare 'rcx', 'setge'}
    #{CodeGen.exit 'rax'}
  ASM
end
