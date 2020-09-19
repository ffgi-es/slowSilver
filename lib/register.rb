# holds register info
class Register
  attr_reader :r64, :r32, :r16, :r8

  def initialize(reg64, reg32, reg16, reg8)
    @r64 = reg64
    @r32 = reg32
    @r16 = reg16
    @r8 = reg8
  end

  @registers = {
    ax: Register.new('rax', 'eax', 'ax', 'al'),
    cx: Register.new('rcx', 'ecx', 'cx', 'cl'),
    dx: Register.new('rdx', 'edx', 'dx', 'dl'),
    bx: Register.new('rbx', 'ebx', 'bx', 'bl'),
    sp: Register.new('rsp', 'esp', 'sp', 'spl'),
    bp: Register.new('rbp', 'ebp', 'bp', 'bpl'),
    si: Register.new('rsi', 'esi', 'si', 'sil'),
    di: Register.new('rdi', 'edi', 'di', 'dil'),
    "12": Register.new('r12', 'r12d', 'r12w', 'r12b'),
    "14": Register.new('r14', 'r14d', 'r14w', 'r14b')
  }

  def self.[](key)
    @registers.fetch key
  end

  def to_s
    @r64
  end
end
