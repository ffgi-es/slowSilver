require_relative 'shared'

describe 'lists1.sag' do
  include_context 'component test', 'fixtures/lists1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:function_call, 'sum'),
    Token.new(:open_list),
    Token.new(:close_list),
    Token.new(:end),
    Token.new(:identifier, 'sum'),
    Token.new(:type, :"LIST<INT>"),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:function_line),
    Token.new(:identifier, 'sum'),
    Token.new(:open_list),
    Token.new(:close_list),
    Token.new(:return),
    Token.new(:integer_constant, 0),
    Token.new(:break),
    Token.new(:identifier, 'sum'),
    Token.new(:variable, 'List'),
    Token.new(:return),
    Token.new(:integer_constant, 1),
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
              :sum,
              List.empty)))),
      Function.new(
        'sum',
        { [:"LIST<INT>"] => :INT },
        Clause.new(
          List.empty,
          nil,
          Return.new(
            IntegerConstant.new(0))),
        Clause.new(
          Parameter.new('List'),
          nil,
          Return.new(
            IntegerConstant.new(1))))))

  # include_examples 'no validation error'

  # include_examples 'generation', '_main', <<~ASM
  #  #{CodeGen.externs}

  #  SECTION .text
  #  global _main

  #  _main:
  #      call    init
  #      mov     rax, 2
  #      push    rax
  #      mov     rax, 2
  #      pop     rcx
  #      add     rax, rcx
  #  #{CodeGen.exit 'rax'}
  # ASM
end
