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

    def parse_var(token, params = [])
      if params.any? { |x| x.respond_to?(:head) && x.head == token.value }
        return HeadVariable.new(token.value)
      end
      if params.any? { |x| x.respond_to?(:tail) && x.tail == token.value }
        return TailVariable.new(token.value)
      end

      Variable.new(token.value)
    end
  end
end
