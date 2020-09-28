require_relative 'ast/program'
require_relative 'ast/parameter'
require_relative 'ast/variable'
require_relative 'ast/return'
require_relative 'ast/expression'
require_relative 'ast/integer_constant'
require_relative 'ast/function'
require_relative 'ast/clause'
require_relative 'ast/string_constant'
require_relative 'compile_error'

# root of the AST
class ASTree
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def code
    <<~ASM
      extern init
      extern alloc

      SECTION .text
    ASM
      .concat @program.code
      .concat data_section
  end

  def validate
    @program.validate
  end

  private

  def data_section
    DataLabel.reset
    data = @program.data
    return '' if data.empty?

    "\nSECTION .data\n" << data
  end
end
