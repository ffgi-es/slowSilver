class Parser
  def self.parse(tokens)
    ASTree.new(parse_program(tokens))
  end

  def self.parse_program(tokens)
    Program.new(parse_function(tokens))
  end
  
  def self.parse_function(tokens)
    tokens.shift
    name = tokens.shift.value
    tokens.shift
    return_exp = parse_exp(tokens)
    Function.new(name, return_exp)
  end

  def self.parse_exp(tokens)
    Return.new(parse_int(tokens))
  end

  def self.parse_int(tokens)
    IntegerConstant.new(tokens.shift.value)
  end
end

class ASTree
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def ==(other)
    @program == other.program
  end
end

class Program
  attr_reader :function

  def initialize(function)
    @function = function
  end

  def ==(other)
    @function == other.function
  end
end

class Function
  attr_reader :name, :return

  def initialize(name, return_exp)
    @name = name
    @return = return_exp
  end

  def ==(other)
    @name == other.name and
      @return == other.return
  end
end

class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def ==(other)
    @expression == other.expression
  end
end

class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def ==(other)
    @value == other.value
  end
end
