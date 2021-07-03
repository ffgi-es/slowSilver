require_relative 'shared'

describe 'lists1.sag' do
  include_context 'component test', 'fixtures/lists1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'sum'),
    Token.new(:open_list, 3),
    Token.new(:close_list, 3),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'sum'),
    Token.new(:type, 5, :"LIST<INT>"),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'sum'),
    Token.new(:open_list, 7),
    Token.new(:close_list, 7),
    Token.new(:return, 7),
    Token.new(:integer_constant, 7, 0),
    Token.new(:break, 7),

    Token.new(:identifier, 8, 'sum'),
    Token.new(:variable, 8, 'List'),
    Token.new(:return, 8),
    Token.new(:integer_constant, 8, 1),
    Token.new(:end, 8)
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
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:open_expression, 3),
    Token.new(:function_call, 3, 'sum'),
    Token.new(:open_list, 3),
    Token.new(:integer_constant, 3, 5),
    Token.new(:close_list, 3),
    Token.new(:close_expression, 3),
    Token.new(:function_call, 3, '+'),
    Token.new(:open_expression, 3),
    Token.new(:function_call, 3, 'sum'),
    Token.new(:open_list, 3),
    Token.new(:integer_constant, 3, 4),
    Token.new(:close_list, 3),
    Token.new(:close_expression, 3),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'sum'),
    Token.new(:type, 5, :"LIST<INT>"),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'sum'),
    Token.new(:open_list, 7),
    Token.new(:close_list, 7),
    Token.new(:return, 7),
    Token.new(:integer_constant, 7, 0),
    Token.new(:break, 7),

    Token.new(:identifier, 8, 'sum'),
    Token.new(:open_list, 8),
    Token.new(:variable, 8, 'X'),
    Token.new(:close_list, 8),
    Token.new(:return, 8),
    Token.new(:variable, 8, 'X'),
    Token.new(:end, 8)
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

describe 'lists3.sag' do
  include_context 'component test', 'fixtures/lists3.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 1, 'main'),
    Token.new(:return, 1),
    Token.new(:type, 1, :INT),

    Token.new(:entry_function_line, 2),

    Token.new(:identifier, 3, 'main'),
    Token.new(:return, 3),
    Token.new(:function_call, 3, 'sum'),
    Token.new(:open_list, 3),
    Token.new(:integer_constant, 3, 5),
    Token.new(:chain_line, 3),
    Token.new(:open_list, 3),
    Token.new(:integer_constant, 3, 9),
    Token.new(:close_list, 3),
    Token.new(:close_list, 3),
    Token.new(:end, 3),

    Token.new(:identifier, 5, 'sum'),
    Token.new(:type, 5, :"LIST<INT>"),
    Token.new(:return, 5),
    Token.new(:type, 5, :INT),

    Token.new(:function_line, 6),

    Token.new(:identifier, 7, 'sum'),
    Token.new(:open_list, 7),
    Token.new(:close_list, 7),
    Token.new(:return, 7),
    Token.new(:integer_constant, 7, 0),
    Token.new(:break, 7),

    Token.new(:identifier, 8, 'sum'),
    Token.new(:open_list, 8),
    Token.new(:variable, 8, 'X'),
    Token.new(:chain_line, 8),
    Token.new(:open_list, 8),
    Token.new(:close_list, 8),
    Token.new(:close_list, 8),
    Token.new(:return, 8),
    Token.new(:variable, 8, 'X'),
    Token.new(:break, 8),

    Token.new(:identifier, 9, 'sum'),
    Token.new(:open_list, 9),
    Token.new(:variable, 9, 'X'),
    Token.new(:chain_line, 9),
    Token.new(:variable, 9, 'T'),
    Token.new(:close_list, 9),
    Token.new(:return, 9),
    Token.new(:variable, 9, 'X'),
    Token.new(:function_call, 9, '+'),
    Token.new(:open_expression, 9),
    Token.new(:function_call, 9, 'sum'),
    Token.new(:variable, 9, 'T'),
    Token.new(:close_expression, 9),
    Token.new(:end, 9)
  ]

  include_examples 'parsing', ASTree.new(
    Program.new(
      Function.new('main', { [] => :INT },
                   Clause.new(
                     nil,
                     Return.new(
                       Expression.new(
                         :sum,
                         List.new(
                           IntegerConstant.new(5),
                           List.new(
                             IntegerConstant.new(9))))))),
      Function.new(
        'sum',
        { [:"LIST<INT>"] => :INT },
        Clause.new(
          List.empty,
          nil,
          Return.new(
            IntegerConstant.new(0))),
        Clause.new(
          ListParameter.new(:X, List.empty),
          nil,
          Return.new(
            HeadVariable.new(:X))),
        Clause.new(
          ListParameter.new(:X, :T),
          nil,
          Return.new(
            Expression.new(
              :+,
              HeadVariable.new(:X),
              Expression.new(
                :sum,
                TailVariable.new(:T))))))))

  # include_examples 'no validation error'

  # include_examples 'generation', '_main', <<~ASM
  #   #{CodeGen.externs}

  #   SECTION .text
  #   global _main

  #   _main:
  #       call    init
  #       mov     rax, list10
  #       push    rax
  #       call    _sum
  #       add     rsp, 8
  #       push    rax
  #       mov     rax, list00
  #       push    rax
  #       call    _sum
  #       add     rsp, 8
  #       pop     rcx
  #       add     rax, rcx
  #   #{CodeGen.exit 'rax'}

  #   _sum:
  #       push    rbp
  #       mov     rbp, rsp
  #   _sum0:
  #       mov     rax, 0
  #       cmp     rax, [rbp+16]
  #       jne     _sum1
  #       mov     rax, 0
  #       jmp     _sumdone
  #   _sum1:
  #       mov     rax, [rbp+16]
  #       mov     rax, [rax]
  #   _sumdone:
  #       mov     rsp, rbp
  #       pop     rbp
  #       ret

  #   SECTION .data
  #   list00  dq 5
  #   list00p dq 0
  #   list10  dq 4
  #   list10p dq 0
  # ASM
end
