# a node in a linked list
class List
  attr_reader :name

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
