class PPrinter
  def self.format(ast)
    format_program("", ast.program) if ast.is_a? ASTree
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
      format_integer(output, function.return.expression)
    end

    def format_integer(output, integer)
      output << "      - int: #{integer.value}\n"
    end
  end
end
