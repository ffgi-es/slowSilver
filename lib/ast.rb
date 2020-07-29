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

  def code(reg, parameters)
    ind = (parameters.count + 1) - parameters.index(@name)
    "mov #{reg.r64}, [rbp+#{8 * ind}]".asm
  end
end

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def code(entry, parameters = [])
    result = @expression.code(Register[:bx], parameters)
    if entry
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

  @registers = [
    Register[:dx],
    Register[:cx],
    Register[:bx]
  ]

  @actions = {
    :+ => proc do |res, reg, regs|
      res \
        << "pop #{reg.r64}".asm \
        << "add #{reg.r64}, #{regs[0].r64}".asm
    end,

    :- => proc do |res, reg, regs|
      res \
        << "pop #{reg.r64}".asm \
        << "sub #{reg.r64}, #{regs[0].r64}".asm
    end,

    :"=" => proc do |res, reg, regs|
      res \
        << "pop #{regs[1].r64}".asm \
        << "cmp #{regs[1].r64}, #{regs[0].r64}".asm \
        << "sete #{reg.r8}".asm
    end,

    :! => proc do |res, reg, regs|
      res \
        << "cmp #{regs[0].r64}, 0".asm \
        << "sete #{reg.r8}".asm
    end
  }

  class << self
    attr_reader :registers, :actions

    def registers_except(reg)
      @registers.filter { |r| r != reg }
    end
  end

  def initialize(function, *params)
    @function = function
    @parameters = params
    @action = self.class.actions[function]
  end

  def code(reg, func_params = [])
    regs = self.class.registers_except reg

    res = get_parameters regs, func_params

    if @action
      @action.call(res, reg, regs)
    else
      res << 'push rdx'.asm unless @parameters.empty?
      res << "call _#{function}".asm
    end
  end

  def get_parameters(regs, func_params)
    return '' if @parameters.empty?
    return @parameters.first.code(regs[0], func_params) if @parameters.count == 1

    output = @parameters[0..-2].reduce('') do |out, param|
      out << param.code(regs[0], func_params)
      out << "push #{regs[0].r64}".asm
    end
    output << @parameters.last.code(regs[0], func_params)
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def code(reg, _)
    "mov #{reg.r64}, #{value}".asm
  end
end

# add helper formatting function to String class
class String
  def asm
    gsub(/^(\w+) /) { |cmd| "    #{cmd.ljust 8}" } << "\n"
  end
end
