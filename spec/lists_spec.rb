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

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 0
        push    rax
        call    _sum
        add     rsp, 8
    #{CodeGen.exit 'rax'}

    _sum:
        push    rbp
        mov     rbp, rsp
    _sum0:
        mov     rax, 0
        cmp     rax, [rbp+16]
        jne     _sum1
        mov     rax, 0
        jmp     _sumdone
    _sum1:
        mov     rax, 1
    _sumdone:
        mov     rsp, rbp
        pop     rbp
        ret
  ASM
end

describe 'lists2.sag' do
  include_context 'component test', 'fixtures/lists2.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:open_expression),
    Token.new(:function_call, 'sum'),
    Token.new(:open_list),
    Token.new(:integer_constant, 5),
    Token.new(:close_list),
    Token.new(:close_expression),
    Token.new(:function_call, '+'),
    Token.new(:open_expression),
    Token.new(:function_call, 'sum'),
    Token.new(:open_list),
    Token.new(:integer_constant, 4),
    Token.new(:close_list),
    Token.new(:close_expression),
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
    Token.new(:open_list),
    Token.new(:variable, 'X'),
    Token.new(:close_list),
    Token.new(:return),
    Token.new(:variable, 'X'),
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
              Expression.new(
                :sum,
                List.new(
                  IntegerConstant.new(5))),
              Expression.new(
                :sum,
                List.new(
                  IntegerConstant.new(4))))))),
      Function.new(
        'sum',
        { [:"LIST<INT>"] => :INT },
        Clause.new(
          List.empty,
          nil,
          Return.new(
            IntegerConstant.new(0))),
        Clause.new(
          ListParameter.new(:X),
          nil,
          Return.new(
            HeadVariable.new(:X))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, list10
        push    rax
        call    _sum
        add     rsp, 8
        push    rax
        mov     rax, list00
        push    rax
        call    _sum
        add     rsp, 8
        pop     rcx
        add     rax, rcx
    #{CodeGen.exit 'rax'}

    _sum:
        push    rbp
        mov     rbp, rsp
    _sum0:
        mov     rax, 0
        cmp     rax, [rbp+16]
        jne     _sum1
        mov     rax, 0
        jmp     _sumdone
    _sum1:
        mov     rax, [rbp+16]
        mov     rax, [rax]
    _sumdone:
        mov     rsp, rbp
        pop     rbp
        ret

    SECTION .data
    list00  dq 5
    list00p dq 0
    list10  dq 4
    list10p dq 0
  ASM
end
