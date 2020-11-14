class Declaration

  attr_reader :name, :expression

  def initialize(name, expression)
    @name = name
    @expression = expression
  end

  def code(parameters)
    @expression.code(parameters)
  end

  def type(param_types)
    @expression.type(param_types)
  end
end
