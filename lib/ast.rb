require_relative 'ast/program'
require_relative 'ast/parameter'
require_relative 'ast/variable'
require_relative 'ast/return'
require_relative 'ast/expression'
require_relative 'ast/integer_constant'
require_relative 'ast/function'
require_relative 'ast/clause'
require_relative 'ast/string_constant'

# root of the AST
class ASTree
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def code
    "SECTION .text\n" << @program.code
  end
end
