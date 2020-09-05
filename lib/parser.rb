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
    integer_constant: proc { |details, token, _| details.push(parse_int([token])) },
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
      name = tokens.shift.value

      tokens = tokens.drop_while { |t| t.type != :identifier }

      clauses = tokens
        .slice_after(Token.new(:break))
        .reduce([]) { |res, clause_tokens| res.push parse_clause(clause_tokens) }

      Function.new(name, *clauses)
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
      type == :return || type == :condition
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
      return parse_int(tokens) if tokens.length == 1 && tokens.first.type == :integer_constant
      return parse_var(*tokens) if tokens.length == 1 && tokens.first.type == :variable

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

    def parse_int(tokens)
      IntegerConstant.new(tokens.shift.value)
    end

    def parse_var(token)
      Variable.new(token.value)
    end
  end
end

class ParseError < StandardError
end
