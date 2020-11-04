# holds the inbuilt function actions
class Action
  @actions = Hash.new(
    proc do |name, params|
      next "call _#{name}".asm if params.empty?

      ''.concat "push #{Register[:ax]}".asm
        .concat "call _#{name}".asm
        .concat "add #{Register[:sp]}, #{params.count * 8}".asm
    end)

  @actions[:+] = proc { arithmacy 'add' }

  @actions[:-] = proc { arithmacy 'sub' }

  @actions[:"="] = proc { 'compare sete'.asm }

  @actions[:<] = proc { 'compare setl'.asm }

  @actions[:<=] = proc { 'compare setle'.asm }

  @actions[:>] = proc { 'compare setg'.asm }

  @actions[:>=] = proc { 'compare setge'.asm }

  @actions[:!] = proc { 'compare sete, 0'.asm }

  @actions[:*] = proc { 'multiply rax'.asm }

  @actions[:/] = proc { division }

  @actions[:%] = proc do
    division
      .concat "mov #{Register[:ax]}, #{Register[:dx]}".asm
  end

  @actions[:print] = proc { "print #{Register[:ax]}".asm }

  @actions[:concat] = proc { "concat #{Register[:ax]}".asm }

  class << self
    def [](name)
      @actions[name]
    end

    private

    def arithmacy(operation)
      ''.concat "pop #{Register[:cx]}".asm
        .concat "#{operation} #{Register[:ax]}, #{Register[:cx]}".asm
    end

    def division
      ''.concat "pop #{Register[:cx]}".asm
        .concat "xor #{Register[:dx]}, #{Register[:dx]}".asm
        .concat "idiv #{Register[:cx]}".asm
    end
  end
end
