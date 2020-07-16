# Creates an AST from a list of tokens
class Parser
  def self.parse(tokens)
    ASTree.new(parse_program(tokens))
  end

  def self.parse_program(tokens)
    Program.new(parse_function(tokens))
  end

  def self.parse_function(tokens)
    raise ParseError, "Unexpected token: 'main'" unless tokens.shift.type == :type

    name = tokens.shift.value
    raise ParseError, "Unexpected token: '6'" unless tokens.shift.type == :return

    Function.new(name, parse_exp(tokens))
  end

  def self.parse_exp(tokens)
    Return.new(parse_int(tokens))
  end

  def self.parse_int(tokens)
    raise ParseError, "Unexpected token: '.'" if tokens.first.type != :integer_constant

    int = IntegerConstant.new(tokens.shift.value)
    raise ParseError, "Expected token: '.'" unless tokens.shift&.type == :end

    int
  end
end

class ParseError < StandardError
end

# root of the AST
class ASTree
  attr_reader :program

  def initialize(program)
    @program = program
  end
end

# The program of the AST
class Program
  attr_reader :function

  def initialize(function)
    @function = function
  end
end

# A function in the program
class Function
  attr_reader :name, :return

  def initialize(name, return_exp)
    @name = name
    @return = return_exp
  end
end

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end
end
