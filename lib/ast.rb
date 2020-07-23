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
    @expression.code('rbx') \
      << "    mov     rax, 1\n" \
      << "    int     80h\n"
  end
end

# an expression with a function call
class Expression
  attr_reader :function, :parameters

  def initialize(function, param1, param2)
    @function = function
    @parameters = [param1, param2]
  end

  def code(reg)
    oreg = reg == 'rdx' ? 'rcx' : 'rdx'

    res = @parameters[0].code(oreg) \
      << "    push    #{oreg}\n" \
      << @parameters[1].code(oreg) \

    case @function
    when :+
      res \
        << "    pop     #{reg}\n" \
        << "    add     #{reg}, #{oreg}\n"
    when :"="
      res \
        << "    pop     rcx\n" \
        << "    cmp     rcx, rdx\n" \
        << "    sete    bl\n"
    else
      res \
        << "    pop     #{reg}\n" \
        << "    sub     #{reg}, #{oreg}\n"
    end
  end
end

# a constant integer value
class IntegerConstant
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def code(reg)
    "    mov     #{reg}, #{value}\n"
  end
end
