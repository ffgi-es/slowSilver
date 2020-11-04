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

  def self.multiply(reg)
    <<-ASM
    multiply #{reg}
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
    concat  rax
    ASM
      .chomp
  end
end
