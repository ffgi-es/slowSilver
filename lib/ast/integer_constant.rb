require_relative 'helpers'
require_relative '../register'

# a constant integer value
class IntegerConstant
  attr_reader :value, :name

  def initialize(value)
    @value = value
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{value}".asm
  end

  def type
    :INT
  end
end
