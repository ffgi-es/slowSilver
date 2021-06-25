require_relative 'helpers'
require_relative '../register'
require_relative 'constant'

# a constant integer value
class IntegerConstant < Constant
  attr_reader :value, :name

  def initialize(value)
    @value = value
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{value}".asm
  end

  def type(_)
    :INT
  end
end
