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
  attr_reader :function

  def initialize(function)
    @function = function
  end

  def code
    @function.code
  end
end

# A function in the program
class Function
  attr_reader :name, :return

  def initialize(name, return_exp)
    @name = name
    @return = return_exp
  end

  def code
    "global _#{name}\n\n" \
      << "_#{name}:\n" \
      << @return.code
  end
end

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def code
    @expression.code(Register[:bx]) \
      << 'mov rax, 1'.asm \
      << 'int 80h'.asm
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

  def code(reg)
    regs = self.class.registers_except reg

    res = get_parameters regs

    @action.call(res, reg, regs)
  end

  def get_parameters(regs)
    return @parameters.first.code(regs[0]) if @parameters.count == 1

    @parameters[0].code(regs[0]) \
      << "push #{regs[0].r64}".asm \
      << @parameters[1].code(regs[0])
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def code(reg)
    "mov #{reg.r64}, #{value}".asm
  end
end

# add helper formatting function to String class
class String
  def asm
    gsub(/^(\w+) /) { |cmd| "    #{cmd.ljust 8}" } << "\n"
  end
end
