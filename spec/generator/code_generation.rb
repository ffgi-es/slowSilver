class CodeGen
  def self.exit(exit_code)
    <<-ASM
    mov     rdi, #{exit_code}
    mov     rax, 60
    syscall
    ASM
      .chomp
  end

  def self.compare(opcode, against = nil)
    <<-ASM
    compare #{opcode}#{against.nil? ? nil : ", #{against}"}
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
    print   #{str_ptr}
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
