# Generates assembly code from a given AST
class Generator
  def self.generate_asm(ast)
    output = "SECTION .text\n"
    traverse(ast.program, output)
  end

  def self.traverse(ast, output)
    return traverse(ast.function, output) if ast.is_a? Program

    if ast.is_a? Function
      output << "global _#{ast.name}\n\n"
      output << "_#{ast.name}:\n"
      return traverse(ast.return, output)
    end

    if ast.is_a? Return
      output = traverse(ast.expression, output)
      output << "    mov     eax, 1\n"
      return output << "    int     80h\n"
    end

    return output << "    mov     ebx, #{ast.value}\n" if ast.is_a? IntegerConstant

    output
  end
end
