# Generates assembly code from a given AST
class Generator
  attr_reader :code

  def initialize(ast)
    @code = "SECTION .text\n"
    traverse ast.program
  end
  
  def traverse(ast)
    return traverse ast.function if ast.is_a? Program

    if ast.is_a? Function
      @code << "global _#{ast.name}\n\n"
      @code << "_#{ast.name}:\n"
      return traverse ast.return
    end

    if ast.is_a? Return
      @code = traverse ast.expression
      @code << "    mov     eax, 1\n"
      return @code << "    int     80h\n"
    end

    @code << "    mov     ebx, #{ast.value}\n" if ast.is_a? IntegerConstant
  end
end
