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
      if p.is_a? ListParameter
        v_t[p.head] = inner_list_type(t)
        v_t[p.tail] = t if p.tail
      end
    end
    @condition&.validate(variable_types, :BOOL)
    @return.validate(variable_types, return_type)
  end

  private

  def parameter_indices
    @parameters.each_with_index.each_with_object({}) do |(p, i), inds|
      if p.is_a? Parameter
        inds.update(p.name => i + 2)
      elsif p.is_a? ListParameter
        inds.update(p.head => i + 2)
        inds.update(p.tail => i + 2) if p.tail.is_a? String
      end
    end
  end

  def parameter_check(parameter, function_name, clause_index, parameter_index)
    if parameter.is_a?(IntegerConstant) || parameter.is_a?(List)
      return const_parameter_check(parameter, function_name, clause_index, parameter_index)
    end

    if parameter.is_a? ListParameter
      if parameter.tail.is_a? List
        return parameter.tail.code
            .concat "mov rcx, [rbp+#{16 + (8 * parameter_index)}]".asm
            .concat 'mov rcx, [rcx+8]'.asm
            .concat 'cmp rax, rcx'.asm
            .concat "jne _#{function_name}#{clause_index + 1}".asm
      end
    end

    ''
  end

  def const_parameter_check(parameter, function_name, clause_index, parameter_index)
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
