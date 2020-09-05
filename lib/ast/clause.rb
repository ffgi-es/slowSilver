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
      .concat @return.code(@parameters.map(&:name), done)
  end

  def single_code
    @return.code(@parameters.map(&:name))
  end

  private

  def parameter_check(parameter, function_name, clause_index, parameter_index)
    return '' unless parameter.is_a? IntegerConstant

    parameter.code
      .concat "cmp rax, [rbp+#{16 + (8 * parameter_index)}]".asm
      .concat "jne _#{function_name}#{clause_index + 1}".asm
  end

  def condition_code(name, index)
    return '' if @condition.nil?

    @condition.code(@parameters.map(&:name))
      .concat 'cmp rax, 1'.asm
      .concat "jne _#{name}#{index + 1}".asm
  end
end
