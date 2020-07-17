# Generates assembly code from a given AST
class Generator
  attr_reader :code, :entry_point

  def initialize(ast)
    @code = ast.code
    @entry_point = '_' << ast.program.function.name
  end
end
