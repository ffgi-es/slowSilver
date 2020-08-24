class CodeGen
  def self.exit(exit_code)
    <<-ASM
    mov     rbx, #{exit_code}
    mov     rax, 1
    int     80h
    ASM
      .chomp
  end
end
