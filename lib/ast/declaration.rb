class Declaration

  attr_reader :name, :expression

  def initialize(name, expression)
    @name = name
    @expression = expression
  end
end
