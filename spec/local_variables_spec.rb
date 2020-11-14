require_relative 'shared'

describe 'local_variables1.sag' do
  include_context 'component test', 'fixtures/local_variables1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:variable, 'A'),
    Token.new(:assign),
    Token.new(:integer_constant, 3),
    Token.new(:separator),
    Token.new(:variable, 'A'),
    Token.new(:function_call, '*'),
    Token.new(:integer_constant, 5),
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
            Declaration.new(
              'A',
              IntegerConstant.new(3)),
            Expression.new(
              :*,
              Variable.new('A'),
              IntegerConstant.new(5)))))))

 # include_examples 'no validation error'

 # include_examples 'generation', '_main', <<~ASM
 #   #{CodeGen.externs}

 #   SECTION .text
 #   global _main

 #   _main:
 #       call    init
 #       mov     rax, 2
 #       push    rax
 #       mov     rax, 2
 #       pop     rcx
 #       add     rax, rcx
 #   #{CodeGen.exit 'rax'}
 # ASM
end
