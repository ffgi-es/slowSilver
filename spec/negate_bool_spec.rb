require_relative 'shared'

describe 'not1.sag' do
  include_context 'component test', 'fixtures/not1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :BOOL),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:function_call, '!'),
    Token.new(:open_expression),
    Token.new(:integer_constant, 4),
    Token.new(:function_call, '='),
    Token.new(:integer_constant, 8),
    Token.new(:close_expression),
    Token.new(:end)
  ]

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new(
        'main',
        { [] => :BOOL },
        Clause.new(
          nil,
          Return.new(
            Expression.new(
              :!,
              Expression.new(
                :"=",
                IntegerConstant.new(4),
                IntegerConstant.new(8))))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 8
        push    rax
        mov     rax, 4
        pop     rcx
    #{CodeGen.compare 'rcx'}
    #{CodeGen.compare '0'}
    #{CodeGen.exit 'rax'}
  ASM
end
