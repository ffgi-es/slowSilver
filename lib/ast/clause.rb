require_relative 'helpers'

# a single match of a matched function
class Clause
  attr_reader :parameters, :condition, :return

  def initialize(*params, condition, return_expr)
    @parameters = params
    @condition = condition
    @return = return_expr
  end

  def code(name, index)
    start = "_#{name}#{index}:\n"
    done =  "_#{name}done"
    @parameters
      .each_with_index
      .reduce(start) { |code, (p, i)| code << parameter_check(p, name, index, i) }
      .concat condition_code(name, index)
      .concat @return.code(parameter_indices, done)
  end

  def single_code
    @return.code(parameter_indices)
  end

  def data
    @return.data
  end

  def validate(param_types, return_type)
    variable_types = @parameters
      .zip(param_types)
      .each_with_object({}) do |(p, t), v_t|
      v_t[p.name] = t if p.is_a? Parameter
      if p.is_a? List
        v_t[p.value.name] = inner_list_type(t) if p.value.is_a? Parameter
      end
    end
    @condition&.validate(variable_types, :BOOL)
    @return.validate(variable_types, return_type)
  end

  private

  def parameter_indices
    @parameters.each_with_index.reduce({}) { |inds, (p, i)| inds.update(p.name => i + 2) }
  end

  def parameter_check(parameter, function_name, clause_index, parameter_index)
    return '' unless parameter.is_a?(IntegerConstant) || parameter.is_a?(List)

    parameter.code
      .concat "cmp rax, [rbp+#{16 + (8 * parameter_index)}]".asm
      .concat "jne _#{function_name}#{clause_index + 1}".asm
  end

  def condition_code(name, index)
    return '' if @condition.nil?

    @condition.code(parameter_indices)
      .concat 'cmp rax, 1'.asm
      .concat "jne _#{name}#{index + 1}".asm
  end

  def inner_list_type(type)
    /^LIST<(?<inner_type>.+)>$/.match(type.to_s)['inner_type'].to_sym
  end
end
