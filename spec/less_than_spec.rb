require_relative 'shared'

describe 'less_than_equal1.sag' do
  include_context 'component test', 'fixtures/less_than_equal1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :BOOL),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:integer_constant, 5),
    Token.new(:function_call, '<='),
    Token.new(:integer_constant, 6),
    Token.new(:end)
  ]

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 6
        push    rax
        mov     rax, 5
        pop     rcx
    #{CodeGen.compare 'rcx', 'setle'}
    #{CodeGen.exit 'rax'}
  ASM
end

describe 'less_than1.sag' do
  include_context 'component test', 'fixtures/less_than1.sag'

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 2
        push    rax
        mov     rax, 1
        pop     rcx
    #{CodeGen.compare 'rcx', 'setl'}
    #{CodeGen.exit 'rax'}
  ASM
end
