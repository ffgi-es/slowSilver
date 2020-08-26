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
end
