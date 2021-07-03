require_relative 'shared'

describe 'less_than_equal1.sag' do
  include_context 'component test', 'fixtures/less_than_equal1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :BOOL),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:integer_constant, 3, 5),
    Token.new(:function_call, 3, '<='),
    Token.new(:integer_constant, 3, 6),
    Token.new(:end, 3)
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
    #{CodeGen.compare 'setle'}
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
    #{CodeGen.compare 'setl'}
    #{CodeGen.exit 'rax'}
  ASM
end
