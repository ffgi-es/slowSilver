require_relative 'helpers'

# what a function returns
class Return
  attr_reader :expression, :declarations

  def initialize(*declarations, expression)
    @declarations = declarations
    @expression = expression
  end

  def code(parameters = {}, done_name = nil)
    params = parameters.merge(declared_indices)

    output = @declarations.reduce('') do |out, dec|
      out
        .concat dec.code(params)
        .concat "push #{Register[:ax]}".asm
    end

    if done_name
      return output
          .concat @expression.code(params)
          .concat "jmp #{done_name}".asm
    end

    output << @expression.code(params)
  end

  def data
    @declarations.reduce('') { |out, dec| out << dec.data }
      .concat(@expression.respond_to?(:data) ? @expression.data : '')
  end

  def validate(param_types, return_type)
    all_types = param_types.merge(declared_types(param_types))

    @declarations.each { |dec| dec.validate(all_types) }

    return @expression.validate(all_types, return_type) if @expression.is_a? Expression

    throw_return_error(param_types, return_type) if return_type != @expression.type(all_types)
  end

  private

  def declared_indices
    @declarations.each_with_index.reduce({}) { |inds, (d, i)| inds.update(d.name => -i - 1) }
  end

  def declared_types(param_types)
    @declarations.each_with_object({}) do |dec, types|
      types[dec.name] = dec.type(param_types.merge(types))
    end
  end

  def throw_return_error(param_types, return_type)
    raise CompileError, <<~ERROR
      '#{@expression.value}' is a #{@expression.type param_types}, not #{return_type}
    ERROR
  end
end
