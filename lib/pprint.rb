# a class for formatting an AST into an more human readable string
class PPrinter
  def self.format(ast)
    format_program('', ast.program) if ast.is_a? ASTree
  end

  class << self
    private

    def format_program(output, program)
      output << "program:\n"
      format_function(output, program.function)
    end

    def format_function(output, function)
      output << "  - func:\n"
      output << "    - name: '#{function.name}'\n"
      output << "    - return:\n"
      format_return(output, function.return)
    end

    def format_return(output, ret)
      return format_integer(output, ret.expression) if ret.expression.is_a? IntegerConstant

      format_expression(output, ret.expression)
    end

    def format_expression(output, expression)
      output << "      - call:\n"
      output << "        - name: #{expression.function}\n"
      output << "        - params:\n"
      output = format_integer(output, expression.parameters.first, 10)
      format_integer(output, expression.parameters[1], 10)
    end

    def format_integer(output, integer, indent = 6)
      output << indent("- int: #{integer.value}\n", indent)
    end

    def indent(string, count)
      ' ' * count << string
    end
  end
end
