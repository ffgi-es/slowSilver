require_relative 'helpers'
require_relative '../register'

# a variable in a function
class Variable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def code(parameters)
    "mov #{Register[:ax]}, [rbp"
      .concat(parameters[@name].positive? ? '+' : '')
      .concat((8 * parameters[@name]).to_s)
      .concat(']')
      .asm
  end

  def type(param_types)
    param_types[@name]
  end
end
