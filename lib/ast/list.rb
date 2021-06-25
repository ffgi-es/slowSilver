require_relative '../data_label'

# a node in a linked list
class List
  attr_reader :value, :name

  def initialize(value = nil, _ref = nil)
    @value = value
    @label = DataLabel.indexed('list').concat('0') if value
  end

  def self.empty
    List.new
  end

  def type(_)
    :"LIST<INT>"
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{@label || 0}".asm
  end

  def data
    return unless @label

    "#{@label}  dq #{value.value}\n"
      .concat "#{@label}p dq 0\n"
  end
end

# a list heading used in clause parameters
class ListParameter
  attr_reader :head

  def initialize(head)
    @head = head
  end
end

# a variable that refers to something held at the head of a list
class HeadVariable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def code(parameters)
    "mov #{Register[:ax]}, [rbp+#{8 * parameters[@name]}]".asm
      .concat "mov #{Register[:ax]}, [rax]".asm
  end

  def type(param_types)
    param_types[@name]
  end
end
