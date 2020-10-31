# Create AST constants from tokens
class ConstantParser
  class << self
    def parse_int(token)
      IntegerConstant.new(token.value)
    end

    def parse_string(token)
      StringConstant.new(token.value)
    end

    def parse_bool(token)
      BooleanConstant.new(token.value)
    end

    def parse_var(token)
      Variable.new(token.value)
    end
  end
end
