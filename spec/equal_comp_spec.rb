require_relative 'shared'

describe 'simple_comparison1.sag' do
  include_context 'component test', 'fixtures/simple_comparison1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :BOOL),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:integer_constant, 3),
    Token.new(:function_call, '='),
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
        mov     rax, 3
    #{CodeGen.compare 'sete'}
    #{CodeGen.exit 'rax'}
  ASM
end
