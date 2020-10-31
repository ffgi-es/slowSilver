require_relative 'helpers'
require_relative 'functions'

# a function with multiple parameter matched clauses
class Function
  attr_reader :name, :clauses, :return_type, :param_types

  def initialize(name, type_signature, *clauses)
    @name = name
    @return_type = type_signature.values.first
    @param_types = type_signature.keys.first
    @clauses = clauses

    FunctionDictionary.add(@name.to_sym, type_signature)
  end

  def code(entry = false)
    start_function(entry)
      .concat clause_code
      .concat finish_function(entry)
  end

  def data
    @clauses.map(&:data).join
  end

  def validate
    @clauses.each { |c| c.validate(@param_types, @return_type) }
  end

  private

  def start_function(entry)
    if entry
      return "\n" << <<~ASM
        _#{name}:
            call    init
      ASM
    end

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
