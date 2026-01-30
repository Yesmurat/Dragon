.global _boot
.text

_boot:
	# 64-bit immediates
    addi x1, x0, 1
    slli x1, x1, 40        # x1 = 1 << 40

    addi x2, x0, -1        # x2 = 0xFFFF...FFFF

    # 64-bit arithmetic
    add  x3, x1, x1        # x3 = 2 << 40
    sub  x4, x3, x1        # x4 = 1 << 40

    # Word operations (RV64 only)
    addiw x5, x2, 1        # lower 32-bit add, sign-extended
    slliw x6, x5, 3        # shift lower 32 bits

    # Shifts (lower 6 bits used for RV64)
    slli x7, x1, 5
    srli x8, x7, 4
    srai x9, x2, 1         # arithmetic right shift of 64-bit -1

    # Comparisons
    slt  x10, x2, x1       # signed compare
    sltu x11, x2, x1       # unsigned compare

    # Load upper immediate (still 32-bit immediate)
    lui  x12, 0xABCDE
    slli x12, x12, 32      # move to upper 32 bits

    # Memory (64-bit loads/stores)
    addi x13, x0, 0x200
    sd   x12, 0(x13)       # store doubleword
    ld   x14, 0(x13)       # load doubleword

    # Branch
    beq  x12, x14, equal64
    addi x15, x0, 0

equal64:
    bne  x12, x14, end64
    addi x15, x0, 1

    # Jump
    jal  x16, jump_target64
    addi x17, x0, 0

jump_target64:
    jalr x0, 0(x16)

end64:
    nop

.data
variable:
	.word 0xdeadbeef
                    