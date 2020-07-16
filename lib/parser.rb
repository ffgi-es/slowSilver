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

    Function.new(name, parse_ret(tokens))
  end

  def self.parse_ret(tokens)
    raise ParseError, "Expected token: '.'" unless tokens.pop&.type == :end

    Return.new(parse_exp(tokens))
  end

  def self.parse_exp(tokens)
    raise ParseError, "Unexpected token: '.'" if tokens.first.nil?
    return parse_int(tokens) if tokens.length == 1

    function_call = nil
    arguments = []

    until tokens.first.nil?
      case tokens.first.type
      when :function_call then function_call = tokens.shift.value
      when :integer_constant then arguments.push(tokens.shift.value)
      end
    end

    Expression.new(function_call.to_sym, *arguments)
  end

  def self.parse_int(tokens)
    IntegerConstant.new(tokens.shift.value)
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

  def ==(other)
    @program == other.program
  end
end

# The program of the AST
class Program
  attr_reader :function

  def initialize(function)
    @function = function
  end

  def ==(other)
    @function == other.function
  end
end

# A function in the program
class Function
  attr_reader :name, :return

  def initialize(name, return_exp)
    @name = name
    @return = return_exp
  end

  def ==(other)
    @name == other.name &&
      @return == other.return
  end
end

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def ==(other)
    @expression == other.expression
  end
end

class Expression
  attr_reader :function, :parameters

  def initialize(function, param1, param2)
    @function = function
  end

  def ==(other)
    @name == other.function &&
      @parameters == other.parameters
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def ==(other)
    @value == other.value
  end
end
