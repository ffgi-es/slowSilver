require_relative 'register'

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

  def code(entry, parameters = [])
    result = @expression.code(parameters)
    if entry
      result << 'mov rbx, rax'.asm
      result << 'mov rax, 1'.asm << 'int 80h'.asm
    else
      result << 'mov rsp, rbp'.asm << 'pop rbp'.asm unless parameters.empty?
      result << "    ret\n"
    end
  end
end

# an expression with a function call
class Expression
  attr_reader :function, :parameters

  @actions = {
    :+ => proc do |res|
      res << "pop #{Register[:cx]}".asm
      res << "add #{Register[:ax]}, #{Register[:cx]}".asm
    end,

    :- => proc do |res|
      res << "pop #{Register[:cx]}".asm
      res << "sub #{Register[:ax]}, #{Register[:cx]}".asm
    end,

    :"=" => proc do |res|
      res << "mov #{Register[:bx]}, #{Register[:ax]}".asm
      res << "pop #{Register[:cx]}".asm
      res << "xor #{Register[:ax]}, #{Register[:ax]}".asm
      res << "cmp #{Register[:bx]}, #{Register[:cx]}".asm
      res << "sete #{Register[:ax].r8}".asm
    end,

    :! => proc do |res|
      res << "mov #{Register[:bx]}, #{Register[:ax]}".asm
      res << "xor #{Register[:ax]}, #{Register[:ax]}".asm
      res << "cmp #{Register[:bx]}, 0".asm
      res << "sete #{Register[:ax].r8}".asm
    end,

    :* => proc do |res|
      res << "pop #{Register[:cx]}".asm
      res << "imul #{Register[:ax]}, #{Register[:cx]}".asm
    end,

    :/ => proc do |res|
      res << "pop #{Register[:cx]}".asm
      res << "idiv #{Register[:cx]}".asm
    end,

    :% => proc do |res|
      res << "pop #{Register[:cx]}".asm
      res << "idiv #{Register[:cx]}".asm
      res << "mov #{Register[:ax]}, #{Register[:dx]}".asm
    end
  }

  class << self
    attr_reader :actions
  end

  def initialize(function, *params)
    @function = function
    @parameters = params
    @action = self.class.actions[function]
  end

  def code(func_params = [])
    res = get_parameters func_params

    if @action
      @action.call(res)
    else
      res << "push #{Register[:ax]}".asm unless @parameters.empty?
      res << "call _#{function}".asm
      res << "add #{Register[:sp]}, #{@parameters.count * 8}".asm unless @parameters.empty?
      res
    end
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
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def code(_)
    "mov #{Register[:ax]}, #{value}".asm
  end
end

# add helper formatting function to String class
class String
  def asm
    gsub(/^(\w+) /) { |cmd| "    #{cmd.ljust 8}" } << "\n"
  end
end
