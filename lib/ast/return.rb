require_relative 'helpers'

# what a function returns
class Return
  attr_reader :expression

  def initialize(expression)
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
end
