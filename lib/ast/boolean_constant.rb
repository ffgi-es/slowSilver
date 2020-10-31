# A boolean constant
class BooleanConstant
  attr_reader :value

  def initialize(bool)
    @value = bool
  end

  def code(_)
    "mov #{Register[:ax]}, #{value ? 1 : 0}".asm
  end

  def type(_)
    :BOOL
  end
end
