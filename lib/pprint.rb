# a class for formatting an AST into an more human readable string
class PPrinter
  def self.format(ast)
    format_program('', ast.program) if ast.is_a? ASTree
  end

  class << self
    private

    def format_program(output, program)
      output << "program:\n"
      format_function(output, program.function, 2)
      program.functions.each { |func| format_function(output, func, 2) }
      output
    end

    def format_function(output, function, indent)
      return format_match_function(output, function, indent) if function.is_a? MatchFunction
    end

    def format_single_function(output, function, indent)
      output << indent("- func:\n", indent)
      output << indent("- name: '#{function.name}'\n", indent + 2)
      unless function.parameters.empty?
        output << indent("- params:\n", indent + 2)
        function.parameters.reduce(output) { |out, p| out << indent("- name: #{p}\n", indent + 4) }
      end
      format_return(output, function.return, indent + 2)
    end

    def format_match_function(output, function, indent)
      output << indent("- match-func:\n", indent)
      output << indent("- name: '#{function.name}'\n", indent + 2)
      function.clauses.reduce(output) { |out, clause| format_clause(out, clause, indent + 2) }
    end

    def format_clause(output, clause, indent)
      output << indent("- clause:\n", indent)
      output << indent("- params:\n", indent + 2)
      clause.parameters.reduce(output) { |out, param| format_parameter(out, param, indent + 4) }
      format_return(output, clause.return, indent + 2)
    end

    def format_parameter(output, parameter, indent)
      return output << indent("- name: #{parameter.name}\n", indent) if parameter.is_a? Parameter

      output << indent("- int: #{parameter.value}\n", indent) if parameter.is_a? IntegerConstant
    end

    def format_return(output, ret, indent)
      output << indent("- return:\n", indent)
      if ret.expression.is_a? IntegerConstant
        return format_integer(output, ret.expression, indent + 2)
      end
      return format_variable(output, ret.expression, indent + 2) if ret.expression.is_a? Variable

      format_expression(output, ret.expression, indent + 2)
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
