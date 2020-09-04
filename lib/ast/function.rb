require_relative 'helpers'

# a function with multiple parameter matched clauses
class MatchFunction
  attr_reader :name, :clauses

  def initialize(name, *clauses)
    @name = name
    @clauses = clauses
  end

  def code(entry = false)
    start_function(entry)
      .concat clause_code
      .concat finish_function(entry)
  end

  private

  def start_function(entry)
    return "\n_#{name}:\n" if entry

    "\n_#{name}:\n"
      .concat set_stack
  end

  def set_stack
    return '' if @clauses.first.parameters.empty?

    'push rbp'.asm << 'mov rbp, rsp'.asm
  end

  def finish_function(entry)
    if entry
      return 'mov rdi, rax'.asm
          .concat 'mov rax, 60'.asm
          .concat 'syscall'.asm
    end

    done_label
      .concat reset_stack
      .concat 'ret'.asm
  end

  def done_label
    return '' if @clauses.count < 2

    "_#{name}done:\n"
  end

  def reset_stack
    return '' if @clauses.first.parameters.empty?

    'mov rsp, rbp'.asm << 'pop rbp'.asm
  end

  def clause_code
    return @clauses.first.single_code if @clauses.count == 1

    @clauses
      .map.with_index { |clause, index| clause.code(name, index) }
      .join
      .gsub(/^\s*jmp\s+_\w+done\n\Z/, '')
  end
end
