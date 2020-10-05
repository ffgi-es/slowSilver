require_relative 'shared'

describe 'strings1.sag' do
  include_context 'component test', 'fixtures/strings1.sag'

  include_examples 'lexing', [
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:type, :INT),
    Token.new(:entry_function_line),
    Token.new(:identifier, 'main'),
    Token.new(:return),
    Token.new(:function_call, 'print'),
    Token.new(:string_constant, 'Hello, World!'),
    Token.new(:end)
  ]

  include_examples 'parsing', ASTree.new(
        Program.new(
          Function.new(
            'main',
            {[] => :INT},
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('Hello, World!')))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, str0
    #{CodeGen.print 'rax'}
    #{CodeGen.exit 'rax'}

    SECTION .data
    str0l   dd 13
    str0    db 'Hello, World!'
  ASM
end

describe 'strings2.sag' do
  include_context 'component test', 'fixtures/strings2.sag'

  include_examples 'parsing', ASTree.new(
        Program.new(
          Function.new(
            'main',
            {[] => :INT},
            Clause.new(
              nil,
              Return.new(
                Expression.new(
                  :enough,
                  IntegerConstant.new(15))))),
          Function.new(
            'enough',
            {[:INT] => :INT},
            Clause.new(
              Parameter.new(:X),
              Expression.new(
                :<,
                Variable.new(:X),
                IntegerConstant.new(20)),
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('too few')))),
            Clause.new(
              Parameter.new(:X),
              Expression.new(
                :<,
                Variable.new(:X),
                IntegerConstant.new(30)),
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('enough')))),
            Clause.new(
              Parameter.new(:X),
              nil,
              Return.new(
                Expression.new(
                  :print,
                  StringConstant.new('too many')))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 15
        push    rax
        call    _enough
        add     rsp, 8
    #{CodeGen.exit 'rax'}

    _enough:
        push    rbp
        mov     rbp, rsp
    _enough0:
        mov     rax, 20
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        mov     rbx, rax
        xor     rax, rax
        cmp     rbx, rcx
        setl    al
        cmp     rax, 1
        jne     _enough1
        mov     rax, str0
    #{CodeGen.print 'rax'}
        jmp     _enoughdone
    _enough1:
        mov     rax, 30
        push    rax
        mov     rax, [rbp+16]
        pop     rcx
        mov     rbx, rax
        xor     rax, rax
        cmp     rbx, rcx
        setl    al
        cmp     rax, 1
        jne     _enough2
        mov     rax, str1
    #{CodeGen.print 'rax'}
        jmp     _enoughdone
    _enough2:
        mov     rax, str2
    #{CodeGen.print 'rax'}
    _enoughdone:
        mov     rsp, rbp
        pop     rbp
        ret
    
    SECTION .data
    str0l   dd 7
    str0    db 'too few'
    str1l   dd 6
    str1    db 'enough'
    str2l   dd 8
    str2    db 'too many'
  ASM
end
