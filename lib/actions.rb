# holds the inbuilt function actions
class Action
  @actions = Hash.new(
    proc do |res, name, params|
      res << "push #{Register[:ax]}".asm unless params.empty?
      res << "call _#{name}".asm
      res << "add #{Register[:sp]}, #{params.count * 8}".asm unless params.empty?
      res
    end)

  @actions[:+] = proc { |res| res << arithmacy('add') }

  @actions[:-] = proc { |res| res << arithmacy('sub') }

  @actions[:"="] = proc { |res| res << compare('sete') }

  @actions[:<] = proc { |res| res << compare('setl') }

  @actions[:!] = proc do |res|
    res << "mov #{Register[:bx]}, #{Register[:ax]}".asm
    res << "xor #{Register[:ax]}, #{Register[:ax]}".asm
    res << "cmp #{Register[:bx]}, 0".asm
    res << "sete #{Register[:ax].r8}".asm
  end

  @actions[:*] = proc { |res| res << arithmacy('imul') }

  @actions[:/] = proc do |res|
    res << "pop #{Register[:cx]}".asm
    res << "idiv #{Register[:cx]}".asm
  end

  @actions[:%] = proc do |res|
    res << "pop #{Register[:cx]}".asm
    res << "idiv #{Register[:cx]}".asm
    res << "mov #{Register[:ax]}, #{Register[:dx]}".asm
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
