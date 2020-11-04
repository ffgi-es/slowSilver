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
    "    compare #{opcode}#{against.nil? ? nil : ", #{against}"}"
  end

  def self.externs
    <<~ASM
      extern init
      extern alloc
    ASM
      .chomp
  end

  def self.multiply(reg)
    "    multiply #{reg}"
  end

  def self.print(str_ptr)
    "    print   #{str_ptr}"
  end

  def self.concat
    '    concat  rax'
  end
end
