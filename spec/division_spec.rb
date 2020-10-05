require_relative 'shared'

describe 'division1.sag' do
  include_context 'component test', 'fixtures/division1.sag'

  include_examples 'no validation error'

  include_examples 'generation', '_main', <<~ASM
    #{CodeGen.externs}

    SECTION .text
    global _main

    _main:
        call    init
        mov     rax, 2
        push    rax
        mov     rax, 8
        pop     rcx
        xor     rdx, rdx
        idiv    rcx
    #{CodeGen.exit 'rax'}
  ASM
end
