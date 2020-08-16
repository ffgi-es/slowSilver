require_relative 'register'
require_relative 'actions'

# root of the AST
class ASTree
  attr_reader :program

  def initialize(program)
    @program = program
  end

  def code
    "SECTION .text\n" << @program.code
  end
end

# The program of the AST
class Program
  attr_reader :function, :functions

  def initialize(entry_function, *functions)
    @function = entry_function
    @functions = functions
  end

  def code
    "global _#{@function.name}\n" \
      << @function.code(true) \
      << @functions.map(&:code).join
  end
end

# A function in the program
class Function
  attr_reader :name, :parameters, :return

  def initialize(name, *params, return_exp)
    @name = name
    @parameters = params.map(&:name)
    @return = return_exp
  end

  def code(entry = false)
    output = "\n_#{name}:\n"
    output << 'push rbp'.asm << 'mov rbp, rsp'.asm unless entry || @parameters.empty?
    output << @return.code(entry, @parameters)
  end
end

# a parameter for a function
class Parameter
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

# a variable in a function
class Variable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def code(parameters)
    ind = parameters.index(@name) + 2
    "mov #{Register[:ax]}, [rbp+#{8 * ind}]".asm
  end
end

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def code(entry, parameters = [], done_name = nil)
    result = @expression.code(parameters)
    if entry
      result << 'mov rbx, rax'.asm
      result << 'mov rax, 1'.asm << 'int 80h'.asm
    elsif done_name.nil?
      result << 'mov rsp, rbp'.asm << 'pop rbp'.asm unless parameters.empty?
      result << "    ret\n"
    else
      result << "jmp #{done_name}".asm
    end
  end
end

# an expression with a function call
class Expression
  attr_reader :function, :parameters

  def initialize(function, *params)
    @function = function
    @parameters = params
    @action = Action[function]
  end

  def code(func_params = [])
    res = get_parameters func_params

    @action.call(res, @function, @parameters)
  end

  def get_parameters(func_params)
    return '' if @parameters.empty?
    return @parameters.first.code(func_params) if @parameters.count == 1

    output = @parameters[1..-1].reverse.reduce('') do |out, param|
      out << param.code(func_params)
      out << "push #{Register[:ax]}".asm
    end
    output << @parameters.first.code(func_params)
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value, :name

  def initialize(value)
    @value = value
  end

  def code(_ = nil)
    "mov #{Register[:ax]}, #{value}".asm
  end
end

# a function with multiple parameter matched clauses
class MatchFunction
  attr_reader :name, :clauses

  def initialize(name, *clauses)
    @name = name
    @clauses = clauses
  end

  def code
    output = start_function

    param_checks = clause_code

    output << param_checks.join

    output << finish_function
  end

  private

  def start_function
    output = "\n_#{name}:\n"
    output << 'push rbp'.asm << 'mov rbp, rsp'.asm
  end

  def finish_function
    output = "_#{name}done:\n"
    output << 'mov rsp, rbp'.asm
    output << 'pop rbp'.asm
    output << "    ret\n"
  end

  def clause_code
    param_checks = []

    @clauses.each_with_index do |clause, index|
      checks = clause.code(name, index)
      param_checks.push checks
    end

    param_checks.last.gsub!(/^\s*jmp\s+_\w+done\n\Z/, '')

    param_checks
  end
end

# a single match of a matched function
class Clause
  attr_reader :parameters, :return

  def initialize(*params, return_expr)
    @parameters = params
    @return = return_expr
  end

  def code(name, index)
    param_checks = "_#{name}#{index}:\n"

    @parameters.each_with_index do |parameter, i|
      if parameter.is_a? IntegerConstant
        param_checks << parameter.code
        param_checks << "cmp rax, [rbp+#{16+(8*i)}]".asm
        param_checks << "jne _#{name}#{index+1}".asm
      end
    end

    param_checks << @return.code(false, @parameters.map(&:name), "_#{name}done")
  end
end

# add helper formatting function to String class
class String
  def asm
    gsub(/^(\w+) /) { |cmd| "    #{cmd.ljust 8}" } << "\n"
  end
end
