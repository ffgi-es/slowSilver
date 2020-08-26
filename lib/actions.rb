# holds the inbuilt function actions
class Action
  @actions = Hash.new(
    proc do |res, name, params|
      res << "push #{Register[:ax]}".asm unless params.empty?
      res << "call _#{name}".asm
      res << "add #{Register[:sp]}, #{params.count * 8}".asm unless params.empty?
      res
    end)

  @actions[:+] = proc do |res|
    res << "pop #{Register[:cx]}".asm
    res << "add #{Register[:ax]}, #{Register[:cx]}".asm
  end

  @actions[:-] = proc do |res|
    res << "pop #{Register[:cx]}".asm
    res << "sub #{Register[:ax]}, #{Register[:cx]}".asm
  end

  @actions[:"="] = proc do |res|
    res << "mov #{Register[:bx]}, #{Register[:ax]}".asm
    res << "pop #{Register[:cx]}".asm
    res << "xor #{Register[:ax]}, #{Register[:ax]}".asm
    res << "cmp #{Register[:bx]}, #{Register[:cx]}".asm
    res << "sete #{Register[:ax].r8}".asm
  end

  @actions[:<] = proc do |res|
    res << "mov #{Register[:bx]}, #{Register[:ax]}".asm
    res << "pop #{Register[:cx]}".asm
    res << "xor #{Register[:ax]}, #{Register[:ax]}".asm
    res << "cmp #{Register[:bx]}, #{Register[:cx]}".asm
    res << "setl #{Register[:ax].r8}".asm
  end

  @actions[:!] = proc do |res|
    res << "mov #{Register[:bx]}, #{Register[:ax]}".asm
    res << "xor #{Register[:ax]}, #{Register[:ax]}".asm
    res << "cmp #{Register[:bx]}, 0".asm
    res << "sete #{Register[:ax].r8}".asm
  end

  @actions[:*] = proc do |res|
    res << "pop #{Register[:cx]}".asm
    res << "imul #{Register[:ax]}, #{Register[:cx]}".asm
  end

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
  end
end
