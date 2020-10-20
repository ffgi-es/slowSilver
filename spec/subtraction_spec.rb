require_relative 'shared'

describe 'subtraction1.sag' do
  include_context 'component test', 'fixtures/subtraction1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:integer_constant, 8),
    Token.new(:function_call, '-'),
    Token.new(:integer_constant, 5),
    Token.new(:end)
  ]

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 5
        push    rax
        mov     rax, 8
        pop     rcx
        sub     rax, rcx
    #{CodeGen.exit 'rax'}
  ASM
end
