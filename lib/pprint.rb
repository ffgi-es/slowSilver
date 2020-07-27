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
      format_function(output, program.functions.first) unless program.functions.empty?
      output
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

    def format_expression(output, expression, indent = 6)
      expression_header(output, expression.function, indent)

      expression.parameters.each do |param|
        if param.is_a? IntegerConstant
          format_integer(output, param, indent + 4)
        else
          format_expression(output, param, indent + 4)
        end
      end

      output
    end

    def expression_header(output, name, indent)
      output << indent("- call:\n", indent)
      output << indent("  - name: #{name}\n", indent)
      output << indent("  - params:\n", indent)
    end

    def format_integer(output, integer, indent = 6)
      output << indent("- int: #{integer.value}\n", indent)
    end

    def indent(string, count)
      ' ' * count << string
    end
  end
end
