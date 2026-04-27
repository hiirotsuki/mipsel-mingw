    .text
    .globl main
    .ent main

main:
    # Prologue (Windows NT MIPS ABI style)
    addiu   $sp, $sp, -32
    sw      $ra, 28($sp)

    # Get handle to stdout: GetStdHandle(-11)
    li      $a0, -11              # STD_OUTPUT_HANDLE
    jal     GetStdHandle
    nop
    move    $s0, $v0              # save handle

    # Call WriteConsoleA(handle, msg, len, &written, NULL)
    move    $a0, $s0              # handle
    la      $a1, message          # buffer
    li      $a2, 13               # length
    la      $a3, written          # pointer to written

    # 5th argument on stack (NULL)
    sw      $zero, 16($sp)

    jal     WriteConsoleA
    nop

    # ExitProcess(0)
    move    $a0, $zero
    jal     ExitProcess
    nop

    # Epilogue (not reached)
    lw      $ra, 28($sp)
    addiu   $sp, $sp, 32
    jr      $ra
    nop

    .end main

    .data
message:
    .ascii "Hello, World!\n"
written:
    .word 0
