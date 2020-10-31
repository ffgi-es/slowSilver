require_relative 'shared'

describe 'true_keyword.sag' do
  include_context 'component test', 'fixtures/true_keyword.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :BOOL),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:boolean_constant, true),
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
            BooleanConstant.new(true))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 1
    #{CodeGen.exit 'rax'}
  ASM
end

describe 'false_keyword.sag' do
  include_context 'component test', 'fixtures/false_keyword.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :BOOL),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:boolean_constant, false),
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
            BooleanConstant.new(false))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 0
    #{CodeGen.exit 'rax'}
  ASM
end
