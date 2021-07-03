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
      output << indent("- func:\n", indent)
      output << indent("- name: '#{function.name}'\n", indent + 2)
      output << indent("- type:\n", indent + 2)
      output << indent("- return: #{function.return_type}\n", indent + 4)
      format_input(output, function.param_types, indent + 4)
      function.clauses.reduce(output) { |out, clause| format_clause(out, clause, indent + 2) }
    end

    def format_input(output, input, indent)
      if input.empty?
        output << indent("- input:\n", indent)
      else
        types = input.map(&:to_s).join(', ')
        output << indent("- input: #{types}\n", indent)
      end
    end

    def format_clause(output, clause, indent)
      output << indent("- clause:\n", indent)
      output << indent("- params:\n", indent + 2)
      clause.parameters.reduce(output) { |out, param| format_parameter(out, param, indent + 4) }
      output << indent("- cond:\n", indent + 2)
      format_expression(output, clause.condition, indent + 4) if clause.condition
      format_return(output, clause.return, indent + 2)
    end

    def format_parameter(output, parameter, indent)
      return output << indent("- name: #{parameter.name}\n", indent) if parameter.is_a? Parameter

      return format_list_param(output, parameter, indent) if parameter.is_a? ListParameter
      return format_integer(output, parameter, indent) if parameter.is_a? IntegerConstant
      return format_list(output, parameter, indent) if parameter.is_a? List
    end

    def format_list_param(output, parameter, indent)
      output << indent("- list:\n", indent)
      output << indent("- head: #{parameter.head}\n", indent + 2)
      output << if parameter.tail.nil?
                  indent("- next: nil\n", indent + 2)
                elsif parameter.tail.is_a? List
                  indent("- next: empty\n", indent + 2)
                else
                  indent("- next: #{parameter.tail}\n", indent + 2)
                end
    end

    def format_return(output, ret, indent)
      output << indent("- return:\n", indent)

      format_declarations(output, ret.declarations, indent + 2)

      format_return_expression(output, ret.expression, indent)
    end

    def format_declarations(output, declars, indent)
      declars.each do |dec|
        output << indent("- declare:\n", indent)
        output << indent("- name: #{dec.name}\n", indent + 2)
        output << indent("- value:\n", indent + 2)
        format_return_expression(output, dec.expression, indent + 2)
      end
    end

    def format_return_expression(output, expr, indent)
      return format_expression(output, expr, indent + 2) if expr.is_a? Expression

      format_simple_expression(output, expr, indent)
    end

    def format_simple_expression(output, expression, indent)
      return format_integer(output, expression, indent + 2) if expression.is_a? IntegerConstant
      return format_boolean(output, expression, indent + 2) if expression.is_a? BooleanConstant
      return format_variable(output, expression, indent + 2) if expression.is_a? Variable
      return format_head_variable(output, expression, indent + 2) if expression.is_a? HeadVariable
    end

    def format_expression(output, expression, indent = 6)
      expression_header(output, expression.function, indent)

      expression.parameters.each do |param|
        format_expression_parameter(output, param, indent + 4)
      end

      output
    end

    def format_expression_parameter(output, param, indent)
      if param.is_a? Constant
        format_constant_parameter(output, param, indent)
      elsif param.is_a? Variable
        format_variable(output, param, indent)
      elsif param.is_a? HeadVariable
        format_head_variable(output, param, indent)
      elsif param.is_a? TailVariable
        format_tail_variable(output, param, indent)
      elsif param.is_a? List
        format_list(output, param, indent)
      else
        format_expression(output, param, indent)
      end
    end

    def format_constant_parameter(output, param, indent)
      if param.is_a? IntegerConstant
        format_integer(output, param, indent)
      elsif param.is_a? StringConstant
        format_string(output, param, indent)
      elsif param.is_a? BooleanConstant
        format_boolean(output, param, indent)
      end
    end

    def expression_header(output, name, indent)
      output << indent("- call:\n", indent)
      output << indent("  - name: #{name}\n", indent)
      output << indent("  - params:\n", indent)
    end

    def format_integer(output, integer, indent = 6)
      output << indent("- int: #{integer.value}\n", indent)
    end

    def format_string(output, string, indent = 6)
      output << indent("- str: '#{string.value}'\n", indent)
    end

    def format_boolean(output, bool, indent = 6)
      output << indent("- bool: #{bool.value}\n", indent)
    end

    def format_list(output, list, indent = 6)
      return output << indent("- list: empty\n", indent) if list.value.nil?

      output << indent("- list:\n", indent)
      output << indent("- value:\n", indent + 2)
      format_list_value(output, list.value, indent + 4)
      format_list_tail(output, list, indent + 2)
    end

    def format_list_tail(output, list, indent)
      if list.next
        output << indent("- next:\n", indent)
        format_list(output, list.next, indent + 2)
      else
        output << indent("- next: empty\n", indent)
      end
    end

    def format_list_value(output, value, indent)
      format_integer(output, value, indent) if value.is_a? IntegerConstant
      output << indent("- name: #{value.name}\n", indent) if value.is_a? Parameter
    end

    def format_variable(output, variable, indent = 6)
      output << indent("- var: #{variable.name}\n", indent)
    end

    def format_head_variable(output, variable, indent)
      output << indent("- headvar: #{variable.name}\n", indent)
    end

    def format_tail_variable(output, variable, indent)
      output << indent("- tailvar: #{variable.name}\n", indent)
    end

    def indent(string, count)
      ' ' * count << string
    end
  end
end
