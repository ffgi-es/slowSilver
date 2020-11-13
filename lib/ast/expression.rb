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

  def validate(param_types, return_type = nil)
    @parameters.each { |p| p.validate(param_types) if p.is_a? Expression }

    definitions = FunctionDictionary[@function]

    check_param_count definitions

    check_types definitions, param_types, return_type
  end

  def type(param_types)
    FunctionDictionary[@function][types(param_types)]
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

  def check_param_count(definitions)
    count = definitions.keys.first.length

    throw_param_count_error count if count != @parameters.length
  end

  def check_types(definitions, param_types, return_type)
    returned_type = definitions[types(param_types)]

    throw_parameter_error unless returned_type
    throw_return_error return_type if return_type && return_type != returned_type
  end

  def throw_param_count_error(expected_count)
    raise CompileError, <<~ERROR
      function ':#{@function}' expects #{expected_count} parameters, received #{@parameters.length}
    ERROR
  end

  def throw_return_error(expected_return_type)
    raise CompileError, <<~ERROR
      function ':#{@function}' returns #{FunctionDictionary[@function].values.first}, not #{expected_return_type}
    ERROR
  end

  def throw_parameter_error
    raise CompileError, <<~ERROR
      function ':#{@function}' expects #{types.size} parameters: #{FunctionDictionary[@function].keys.first.join(', ')}
      received: #{types.join(', ')}
    ERROR
  end

  def types(param_types = {})
    @types ||= @parameters.map { |p| p.type(param_types) }
  end
end
