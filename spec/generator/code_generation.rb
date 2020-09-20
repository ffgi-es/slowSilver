class CodeGen
  def self.exit(exit_code)
    <<-ASM
    mov     rdi, #{exit_code}
    mov     rax, 60
    syscall
    ASM
      .chomp
  end

  def self.compare(against, opcode = 'sete')
    <<-ASM
    mov     rbx, rax
    xor     rax, rax
    cmp     rbx, #{against}
    #{opcode.ljust(8)}al
    ASM
      .chomp
  end

  def self.externs
    <<~ASM
      extern init
      extern alloc
    ASM
      .chomp
  end

  def self.print(str_ptr)
    <<-ASM
    mov     rsi, #{str_ptr}
    movsx   rdx, DWORD [#{str_ptr}-4]
    mov     rdi, 1
    mov     rax, 1
    syscall
    xor     rax, rax
    ASM
      .chomp
  end

  def self.concat
    <<-ASM
    mov     r12, rax
    pop     r14
    movsx   rax, DWORD [r12-4]
    movsx   rcx, DWORD [r14-4]
    add     rax, rcx
    add     rax, 4
    call    alloc
    movsx   rbx, DWORD [r12-4]
    movsx   rcx, DWORD [r14-4]
    add     rbx, rcx
    mov     [rax], DWORD ebx
    add     rax, 4
    mov     rdi, rax
    mov     rsi, r12
    movsx   rcx, DWORD [r12-4]
    cld
    rep     movsb
    mov     rsi, r14
    movsx   rcx, DWORD [r14-4]
    rep     movsb
    ASM
      .chomp
  end
end
