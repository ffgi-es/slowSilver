require_relative 'helpers'
require_relative '../register'

# a variable in a function
class Variable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def code(parameters)
    ind = parameters.index(@name) + 2
    "mov #{Register[:ax]}, [rbp+#{8 * ind}]".asm
  end

  def type(param_types)
    param_types[@name]
  end
end
