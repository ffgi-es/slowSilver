require_relative 'shared'

describe 'addition1.sag' do
  include_context 'component test', 'fixtures/addition1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:integer_constant, 2),
    Token.new(:function_call, '+'),
    Token.new(:integer_constant, 2),
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
              :+,
              IntegerConstant.new(2),
              IntegerConstant.new(2)))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 2
        push    rax
        mov     rax, 2
        pop     rcx
        add     rax, rcx
    #{CodeGen.exit 'rax'}
  ASM
end

describe 'addition2.sag' do
  include_context 'component test', 'fixtures/addition2.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:function_call, '+'),
    Token.new(:integer_constant, 2),
    Token.new(:integer_constant, 3),
    Token.new(:end)
  ]
end
