require_relative '../data_label'

# a constant string of character
class StringConstant
  attr_reader :value

  def initialize(value)
    @value = value
    @length = value.length
    @label = DataLabel.indexed 'str'
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{@label}".asm
      .concat "mov #{Register[:dx]}, #{@length}".asm
  end

  def data
    "#{@label}    db '#{@value}'\n"
  end
end
