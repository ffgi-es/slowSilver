require_relative '../data_label'

# a node in a linked list
class List
  attr_reader :value, :next, :name

  def initialize(value = nil, ref = nil)
    @value = value
    @next = ref
    if ref.is_a? List
      @label = ref.give_label
    elsif value
      @label = DataLabel.indexed('list')
    end
    @index = 0
  end

  def self.empty
    List.new
  end

  def type(_)
    :"LIST<INT>"
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{label || 0}".asm
  end

  def data
    return unless @label

    "#{@label}#{@index}  dq #{value.value}\n"
      .concat "#{@label}#{@index}p dq #{@next&.label || 0}\n"
      .concat @next&.data || ''
  end

  def label
    @label ? "#{@label}#{@index}" : nil
  end

  def give_label
    @index += 1
    @next&.give_label || @label
  end
end

# a list heading used in clause parameters
class ListParameter
  attr_reader :head, :tail

  def initialize(head, tail = nil)
    @head = head
    @tail = tail
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

# a variable that refers to the tail of a list
class TailVariable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def code(parameters)
    "mov #{Register[:ax]}, [rbp+#{8 * parameters[@name]}]".asm
      .concat "mov #{Register[:ax]}, [rax+8]".asm
  end

  def type(param_types)
    param_types[@name]
  end
end
