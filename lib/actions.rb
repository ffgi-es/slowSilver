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

  @actions[:<=] = proc { compare 'setle' }

  @actions[:>] = proc { compare 'setg' }

  @actions[:>=] = proc { compare 'setge' }

  @actions[:!] = proc { compare_with('sete', 0) }

  @actions[:*] = proc { 'multiply rax, rcx'.asm }

  @actions[:/] = proc { division }

  @actions[:%] = proc do
    division
      .concat "mov #{Register[:ax]}, #{Register[:dx]}".asm
  end

  @actions[:print] = proc do
    <<-ASM
    mov     #{Register[:si]}, #{Register[:ax]}
    movsx   #{Register[:dx]}, DWORD [#{Register[:ax]}-4]
    mov     #{Register[:di]}, 1
    mov     #{Register[:ax]}, 1
    syscall
    xor     #{Register[:ax]}, #{Register[:ax]}
    ASM
  end

  @actions[:concat] = proc do
    <<-ASM
    mov     #{Register[:"12"]}, #{Register[:ax]}
    pop     #{Register[:"14"]}
    movsx   #{Register[:ax]}, DWORD [#{Register[:"12"]}-4]
    movsx   #{Register[:cx]}, DWORD [#{Register[:"14"]}-4]
    add     #{Register[:ax]}, #{Register[:cx]}
    add     #{Register[:ax]}, 4
    call    alloc
    movsx   #{Register[:bx]}, DWORD [#{Register[:"12"]}-4]
    movsx   #{Register[:cx]}, DWORD [#{Register[:"14"]}-4]
    add     #{Register[:bx]}, #{Register[:cx]}
    mov     [#{Register[:ax]}], DWORD #{Register[:bx].r32}
    add     #{Register[:ax]}, 4
    mov     #{Register[:di]}, #{Register[:ax]}
    mov     #{Register[:si]}, #{Register[:"12"]}
    movsx   #{Register[:cx]}, DWORD [#{Register[:"12"]}-4]
    cld
    rep     movsb
    mov     #{Register[:si]}, #{Register[:"14"]}
    movsx   #{Register[:cx]}, DWORD [#{Register[:"14"]}-4]
    rep     movsb
    ASM
  end

  class << self
    def [](name)
      @actions[name]
    end

    private

    def compare(comparison)
      "pop #{Register[:cx]}".asm << compare_with(comparison, Register[:cx])
    end

    def compare_with(comparison, other)
      ''.concat "mov #{Register[:bx]}, #{Register[:ax]}".asm
        .concat "xor #{Register[:ax]}, #{Register[:ax]}".asm
        .concat "cmp #{Register[:bx]}, #{other}".asm
        .concat "#{comparison} #{Register[:ax].r8}".asm
    end

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
