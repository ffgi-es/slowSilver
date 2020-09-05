# a constant string of character
class StringConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, str0".asm
  end

  def data
    "str0    db '#{@value}'\n"
  end
end
