# a node in a linked list
class List
  attr_reader :value, :name

  def initialize(value = nil, _ref = nil)
    @value = value
  end

  def self.empty
    List.new
  end

  def type(_)
    :"LIST<INT>"
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, 0".asm
  end
end
