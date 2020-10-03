require_relative 'helpers'
require_relative '../actions'
require_relative 'function_dictionary'

# an expression with a function call
class Expression
  attr_reader :function, :parameters

  def initialize(function, *params)
    @function = function
    @parameters = params
    @action = Action[function]
  end

  def code(func_params = [])
    get_parameters(func_params)
      .concat @action.call(@function, @parameters)
  end

  def data
    @parameters.map { |p| p.data if p.respond_to? :data }.join
  end

  def validate
    types = @parameters.map(&:type)
    return if FunctionDictionary[@function][types]

    raise CompileError, <<~ERROR
      #{@function} expects #{types.size} parameters: #{FunctionDictionary[@function].keys.first.join(', ')}
      received: #{types.join(', ')}
    ERROR
  end

  private

  def get_parameters(func_params)
    return '' if @parameters.empty?
    return @parameters.first.code(func_params) if @parameters.count == 1

    output = @parameters[1..-1].reverse.reduce('') do |out, param|
      out << param.code(func_params)
      out << "push #{Register[:ax]}".asm
    end
    output << @parameters.first.code(func_params)
  end
end
