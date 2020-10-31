require_relative 'ast'

# Creates an AST from a list of tokens
class Parser
  def self.parse(tokens)
    ASTree.new(parse_program(tokens))
  end

  @detail_handler = {
    close_expression: proc { |_, _, _| nil },
    open_expression: proc { |details, _, tokens| details.push(parse_exp(tokens)) },
    function_call: proc { |details, token, _| details.unshift(token.value) },
    integer_constant: proc { |details, token, _| details.push(parse_int(token)) },
    string_constant: proc { |details, token, _| details.push(parse_string(token)) },
    variable: proc { |details, token, _| details.push(parse_var(token)) }
  }

  class << self
    private

    def parse_program(tokens)
      funcs = tokens.slice_after(Token.new(:end))
      Program.new(
        parse_function(funcs.first),
        *funcs.drop(1).map { |func| parse_function(func) })
    end

    def parse_function(tokens)
      parts = tokens
        .slice_after { |t| t.type == :function_line || t.type == :entry_function_line }.to_a

      Function.new(
        *function_details(parts[0]),
        *function_clauses(parts[1]))
    end

    def function_details(tokens)
      name = tokens.shift.value

      parts = tokens.slice_after { |t| t.type == :return }.to_a

      [name, { input_types(parts[0]) => parts[1].first.value }]
    end

    def input_types(tokens)
      tokens.each_with_object([]) { |t, arr| arr << t.value if t.type == :type }
    end

    def function_clauses(tokens)
      tokens
        .slice_after(Token.new(:break))
        .reduce([]) { |res, clause_tokens| res.push parse_clause(clause_tokens) }
    end

    def parse_clause(tokens)
      tokens.shift

      params = []

      add_clause_parameter(params, tokens) until end_of_parameters? tokens.first.type

      (return_tokens, condition_tokens) = tokens.slice_before(Token.new(:return)).to_a.reverse

      condition = parse_exp(condition_tokens[1..-1]) if condition_tokens

      Clause.new(*params, condition, parse_ret(return_tokens))
    end

    def end_of_parameters?(type)
      %i[return condition].include? type
    end

    def add_clause_parameter(parameters, tokens)
      case tokens.first.type
      when :integer_constant
        parameters.push IntegerConstant.new(tokens.shift.value)
      when :variable
        parameters.push Parameter.new(tokens.shift.value)
      when :separator
        tokens.shift if tokens.first.type == :separator
      else
        raise ParseError, "Unexpected token: '.'"
      end
    end

    def parse_ret(tokens)
      raise ParseError, "Unexpected token: '6'" unless tokens.shift.type == :return
      unless tokens.last&.type == :end || tokens.last&.type == :break
        raise ParseError, "Expected token: '.'"
      end

      tokens.pop

      Return.new(parse_exp(tokens))
    end

    def parse_exp(tokens)
      raise ParseError, "Unexpected token: '.'" if tokens.first.nil?
      return parse_simple_exp(*tokens) if tokens.length == 1

      parse_function_call(tokens)
    end

    def parse_simple_exp(token)
      return parse_int(token) if token.type == :integer_constant
      return parse_bool(token) if token.type == :boolean_constant
      return parse_var(token) if token.type == :variable

      parse_function_call([token])
    end

    def parse_function_call(tokens)
      function_call, *arguments = parse_details([], tokens)

      Expression.new(function_call.to_sym, *arguments)
    end

    def parse_details(details, tokens)
      return details if tokens.empty?

      parse_details(details, tokens) if detail_handler(details, tokens.shift, tokens)

      details
    end

    def detail_handler(details, token, tokens)
      @detail_handler[token.type].call(details, token, tokens)
    end

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

class ParseError < StandardError
end
