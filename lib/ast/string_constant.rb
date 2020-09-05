require_relative '../data_label'

# a constant string of character
class StringConstant
  attr_reader :value

  def initialize(value)
    @value = value
    @label = DataLabel.indexed 'str'
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{@label}".asm
  end

  def data
    "#{@label}    db '#{@value}',0\n"
  end
end
