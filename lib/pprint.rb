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
      program.functions.each { |func| format_function(output, func) }
      output
    end

    def format_function(output, function)
      output << "  - func:\n"
      output << "    - name: '#{function.name}'\n"
      unless function.parameters.empty?
        output << "    - params:\n"
        function.parameters.reduce(output) { |out, p| out << "      - name: #{p}\n" }
      end
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
        elsif param.is_a? Variable
          format_variable(output, param, indent + 4)
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

    def format_variable(output, variable, indent = 6)
      output << indent("- var: #{variable.name}\n", indent)
    end

    def indent(string, count)
      ' ' * count << string
    end
  end
end
