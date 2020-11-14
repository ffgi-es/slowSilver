require_relative 'helpers'

# what a function returns
class Return
  attr_reader :expression, :declarations

  def initialize(*declarations, expression)
    @declarations = declarations
    @expression = expression
  end

  def code(parameters = [], done_name = nil)
    if done_name
      return @expression.code(parameters)
          .concat "jmp #{done_name}".asm
    end

    @expression.code(parameters)
  end

  def data
    @expression.data if @expression.respond_to? :data
  end

  def validate(param_types, return_type)
    return @expression.validate(param_types, return_type) if @expression.is_a? Expression

    throw_return_error(param_types, return_type) if return_type != @expression.type(param_types)
  end

  private

  def throw_return_error(param_types, return_type)
    raise CompileError, <<~ERROR
      '#{@expression.value}' is a #{@expression.type param_types}, not #{return_type}
    ERROR
  end
end
