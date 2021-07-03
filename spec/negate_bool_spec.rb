require_relative 'shared'

describe 'not1.sag' do
  include_context 'component test', 'fixtures/not1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :BOOL),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, '!'),
    Token.new(:open_expression, 3),
    Token.new(:integer_constant, 3, 4),
    Token.new(:function_call, 3, '='),
    Token.new(:integer_constant, 3, 8),
    Token.new(:close_expression, 3),
    Token.new(:end, 3)
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
    #{CodeGen.compare 'sete'}
    #{CodeGen.compare 'sete', '0'}
    #{CodeGen.exit 'rax'}
  ASM
end
