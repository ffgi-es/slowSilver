require_relative 'shared'

describe 'subtraction1.sag' do
  include_context 'component test', 'fixtures/subtraction1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),
    Token.new(:entry_function_line, 2),
    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:integer_constant, 3, 8),
    Token.new(:function_call, 3, '-'),
    Token.new(:integer_constant, 3, 5),
    Token.new(:end, 3)
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
