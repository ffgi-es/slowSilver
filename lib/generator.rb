# Generates assembly code from a given AST
class Generator
  attr_reader :code, :entry_point

  def initialize(ast)
    @code = "SECTION .text\n"
    traverse ast.program
  end

  def traverse(ast)
    return traverse ast.function if ast.is_a? Program

    if ast.is_a? Function
      @code << "global _#{ast.name}\n\n"
      @code << "_#{ast.name}:\n"
      @entry_point = "_#{ast.name}"
      return traverse ast.return
    end

    if ast.is_a? Return
      traverse ast.expression
      @code << "    mov     rax, 1\n"
      return @code << "    int     80h\n"
    end

    if ast.is_a? Expression
      traverse ast.parameters[0]
      @code << "    push    rbx\n"
      traverse ast.parameters[1]
      @code << "    pop     rcx\n"
      @code << "    add     rbx, rcx\n"
      return
    end

    @code << "    mov     rbx, #{ast.value}\n" if ast.is_a? IntegerConstant
  end
end
