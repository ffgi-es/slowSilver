require_relative 'shared'

describe 'string_addition1.sag' do
  include_context 'component test', 'fixtures/string_addition1.sag'

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
                  Expression.new(
                    :concat,
                    StringConstant.new('This plus'),
                    StringConstant.new(' that'))))))))

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, str1
        push    rax
        mov     rax, str0
    #{CodeGen.concat}
    #{CodeGen.print 'rax'}
    #{CodeGen.exit 'rax'}

    SECTION .data
    str0l   dd 9
    str0    db 'This plus'
    str1l   dd 5
    str1    db ' that'
  ASM
end
