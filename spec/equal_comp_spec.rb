require_relative 'shared'

describe 'simple_comparison1.sag' do
  include_context 'component test', 'fixtures/simple_comparison1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :BOOL),
    Token.new(:entry_function_line, 2),
    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:integer_constant, 4, 3),
    Token.new(:function_call, 4, '='),
    Token.new(:integer_constant, 4, 3),
    Token.new(:end, 4)
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
        mov     rax, 3
    #{CodeGen.compare 'sete'}
    #{CodeGen.exit 'rax'}
  ASM
end
