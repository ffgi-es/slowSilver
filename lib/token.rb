# a representation a single unit of code syntax
class Token
  attr_reader :type, :value

  def initialize(type, value = nil)
    @type = type
    @value = value
  end

  def ==(other)
    @type == other.type &&
      @value == other.value
  end
end
