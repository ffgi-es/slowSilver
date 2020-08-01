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
    bx: Register.new('rbx', 'ebx', 'bx', 'bl'),
    cx: Register.new('rcx', 'ecx', 'cx', 'cl'),
    dx: Register.new('rdx', 'edx', 'dx', 'dl'),
    sp: Register.new('rsp', 'esp', 'sp', 'spl'),
    di: Register.new('rdi', 'edi', 'di', 'dil')
  }

  def self.[](key)
    @registers[key]
  end

  def to_s
    @r64
  end
end
