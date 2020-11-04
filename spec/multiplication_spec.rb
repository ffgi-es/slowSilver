require_relative 'shared'

describe 'multiplication1.sag' do
  include_context 'component test', 'fixtures/multiplication1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:integer_constant, 3),
    Token.new(:function_call, '*'),
    Token.new(:integer_constant, 6),
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
            Expression.new(
              :*,
              IntegerConstant.new(3),
              IntegerConstant.new(6)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 6
        push    rax
        mov     rax, 3
    #{CodeGen.multiply 'rax'}
    #{CodeGen.exit 'rax'}
  ASM
end
