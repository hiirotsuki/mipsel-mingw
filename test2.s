    .text
    .globl main

main:
    addiu $sp, $sp, -32
    sw    $ra, 28($sp)

    li    $a0, -11

    la    $t9, GetStdHandle
    jalr  $t9
    nop

    move  $a0, $v0
    la    $a1, message
    li    $a2, 13
    la    $a3, written
    sw    $zero, 16($sp)

    la    $t9, WriteConsoleA
    jalr  $t9
    nop

    move  $a0, $zero
    la    $t9, ExitProcess
    jalr  $t9
    nop

    .data
message:
    .ascii "Hello, World!\n"
written:
    .word 0
