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
      result << 'mov rdi, rax'.asm
      result << 'mov rax, 60'.asm << 'syscall'.asm
    elsif done_name.nil?
      result << 'mov rsp, rbp'.asm << 'pop rbp'.asm unless parameters.empty?
      result << 'ret'.asm
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
    get_parameters(func_params)
      .concat @action.call(@function, @parameters)
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
    start_function
      .concat clause_code
      .concat finish_function
  end

  private

  def start_function
    "\n_#{name}:\n"
      .concat 'push rbp'.asm
      .concat 'mov rbp, rsp'.asm
  end

  def finish_function
    "_#{name}done:\n"
      .concat 'mov rsp, rbp'.asm
      .concat 'pop rbp'.asm
      .concat 'ret'.asm
  end

  def clause_code
    @clauses
      .map.with_index { |clause, index| clause.code(name, index) }
      .join
      .gsub(/^\s*jmp\s+_\w+done\n\Z/, '')
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
    start = "_#{name}#{index}:\n"
    done =  "_#{name}done"
    @parameters
      .each_with_index
      .reduce(start) { |code, (p, i)| code << parameter_check(p, name, index, i) }
      .concat @return.code(false, @parameters.map(&:name), done)
  end

  private

  def parameter_check(parameter, function_name, clause_index, parameter_index)
    return '' unless parameter.is_a? IntegerConstant

    parameter.code
      .concat "cmp rax, [rbp+#{16 + (8 * parameter_index)}]".asm
      .concat "jne _#{function_name}#{clause_index + 1}".asm
  end
end

# add helper formatting function to String class
class String
  def asm
    gsub(/^(\w+) ?/) { |cmd| "    #{cmd.ljust 8}" }.rstrip << "\n"
  end
end
