# The program of the AST
class Program
  attr_reader :function, :functions

  def initialize(entry_function, *functions)
    @function = entry_function
    @functions = functions
  end

  def code
    "global _#{@function.name}\n" \
      << @function.code(true) \
      << @functions.map(&:code).join
  end

  def data
    @function.data << @functions.map(&:data).join
  end

  def validate
    @function.validate
  end
end
