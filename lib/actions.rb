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

  @actions[:"="] = proc { compare 'sete' }

  @actions[:<] = proc { compare 'setl' }

  @actions[:!] = proc do
    ''.concat "mov #{Register[:bx]}, #{Register[:ax]}".asm
      .concat "xor #{Register[:ax]}, #{Register[:ax]}".asm
      .concat "cmp #{Register[:bx]}, 0".asm
      .concat "sete #{Register[:ax].r8}".asm
  end

  @actions[:*] = proc { arithmacy 'imul' }

  @actions[:/] = proc do
    ''.concat "pop #{Register[:cx]}".asm
      .concat "idiv #{Register[:cx]}".asm
  end

  @actions[:%] = proc do
    ''.concat "pop #{Register[:cx]}".asm
      .concat "idiv #{Register[:cx]}".asm
      .concat "mov #{Register[:ax]}, #{Register[:dx]}".asm
  end

  class << self
    def [](name)
      @actions[name]
    end

    private

    def compare(comparison)
      ''.concat "mov #{Register[:bx]}, #{Register[:ax]}".asm
        .concat "pop #{Register[:cx]}".asm
        .concat "xor #{Register[:ax]}, #{Register[:ax]}".asm
        .concat "cmp #{Register[:bx]}, #{Register[:cx]}".asm
        .concat "#{comparison} #{Register[:ax].r8}".asm
    end

    def arithmacy(operation)
      ''.concat "pop #{Register[:cx]}".asm
        .concat "#{operation} #{Register[:ax]}, #{Register[:cx]}".asm
    end
  end
end
