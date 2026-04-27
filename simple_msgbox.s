    .text
    .globl main

main:
    addiu $sp, $sp, -32
    sw    $ra, 28($sp)

    # MessageBoxA(NULL, text, title, MB_OK)

    move  $a0, $zero          # hWnd = NULL
    la    $a1, text           # lpText
    la    $a2, title          # lpCaption
    li    $a3, 0              # MB_OK

    la    $t9, MessageBoxA
    jalr  $t9
    nop

    # just return (no ExitProcess)
    move  $v0, $zero

    lw    $ra, 28($sp)
    addiu $sp, $sp, 32
    jr    $ra
    nop


    .data

text:
    .asciiz "hello world mips!"

title:
    .asciiz "MIPS"
